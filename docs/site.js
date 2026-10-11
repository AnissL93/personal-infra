// Shared by every page: the dwm-style bar, theme colours (kept across pages), app tables, scripts.
const D = window.DATA, $ = s => document.querySelector(s);
const GH = "https://github.com/AnissL93/";
const UI = ["bg", "bg_alt", "bg_hl", "sel", "dim", "mid", "fg", "bright", "accent", "accent_fg", "bar", "bar_fg", "border"];
const SYN = ["comment", "string", "number", "keyword", "function", "type", "punct", "err", "warn", "ok"];
const ANSI = [...Array(16).keys()].map(i => "color" + i);
const byId = Object.fromEntries(D.themes.map(t => [t.id, t]));
const mode = t => t.mode || "dark";
const esc = s => String(s ?? "").replace(/[&<>"]/g, c => ({ "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;" })[c]);
const nScripts = Object.values(D.scripts).reduce((n, l) => n + l.length, 0);
const nApps = os => D.apps[os].reduce((n, [, rows]) => n + rows.length, 0);
const OCTO = `<svg viewBox="0 0 16 16" aria-hidden="true"><path d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.013 8.013 0 0016 8c0-4.42-3.58-8-8-8z"/></svg>`;

const PAGES = [["index.html", "home"], ["gallery.html", "gallery"], ["install.html", "install"], ["usage.html", "usage"],
  ["linux.html", "linux"], ["macos.html", "macos"], ["apps.html", "apps"]];
const here = location.pathname.split("/").pop() || "index.html";

document.body.insertAdjacentHTML("afterbegin", `<nav class="bar" aria-label="Pages">
  <div class="tags">${PAGES.map(([href, name], i) =>
    `<a href="${href}"${href === here ? ' class="on" aria-current="page"' : ""}><b>${i + 1}</b>${name}</a>`).join("")}</div>
  <div class="title" id="bar-title">personal-infra</div>
  <div class="status"><span id="st-mode"></span><i>│</i><span id="st-clock"></span></div>
  <a class="gh" href="${GH}personal-infra">${OCTO}<span>GitHub</span></a>
</nav>`);
$("main").insertAdjacentHTML("beforeend", `<footer>
  <span>Built from the repo by <code>docs/build.py</code>. Page colours come from the theme you pick in the <a href="gallery.html">gallery</a>.</span>
  <a class="gh-foot" href="${GH}personal-infra">github.com/AnissL93/personal-infra ↗</a>
</footer>`);
document.body.insertAdjacentHTML("beforeend", `<div class="toast" id="toast" role="status"></div>`);

function toast(msg) {
  const el = $("#toast"); el.textContent = msg; el.classList.add("on");
  clearTimeout(toast.t); toast.t = setTimeout(() => el.classList.remove("on"), 1400);
}
function copy(text) { navigator.clipboard?.writeText(text).then(() => toast("copied " + text), () => {}); }

// Paint the page with a theme and remember it, so every page opens in the theme last picked.
function paint(id) {
  const t = byId[id]; if (!t) return;
  const r = document.documentElement.style;
  for (const k of [...UI, ...SYN, ...ANSI]) if (t[k]) r.setProperty("--" + k, t[k]);
  r.setProperty("--wall", t.thumb ? `url("${t.thumb}")` : "none");
  document.documentElement.style.colorScheme = mode(t);
  $("#bar-title").textContent = t.name || t.id;
  $("#st-mode").textContent = mode(t);
  try { localStorage.setItem("theme", id); } catch {}
  window.onTheme?.(t);
}
function startTheme() {
  const fromHash = (location.hash.match(/theme=([\w-]+)/) || [])[1];
  let saved; try { saved = localStorage.getItem("theme"); } catch {}
  const darks = D.themes.filter(t => mode(t) === "dark" && !t.pixel && t.thumb);
  return [fromHash, saved].find(id => byId[id]) || darks[Math.floor(Math.random() * darks.length)].id;
}

const PF = { L: "linux", M: "macos", LM: "both" };
// SOFTWARE.md as tables, one per section; `os` is "linux", "macos" or "all".
function appTables(os, q = "", only = "") {
  return D.apps[os].map(([section, rows]) => {
    const shown = rows.filter(r => (!only || r.pf.includes(only)) &&
      (!q || `${r.app} ${r.how} ${r.config} ${r.notes}`.toLowerCase().includes(q)));
    if (!shown.length) return "";
    return `<table class="apps"><caption>${esc(section)} <small>${shown.length}</small></caption>
      <thead><tr><th>app</th><th>installed by</th><th>config</th><th>notes</th></tr></thead><tbody>${shown.map(r => `<tr>
        <td>${r.app}${r.themed ? '<span class="mark th" title="coloured by theme">themed</span>' : ""}${
          os === "all" ? `<span class="mark both">${PF[r.pf]}</span>` : r.pf === "LM" ? '<span class="mark both">both</span>' : ""}</td>
        <td data-k="installed by">${r.how}</td><td data-k="config">${r.config}</td><td data-k="notes">${r.notes}</td></tr>`).join("")}
      </tbody></table>`;
  }).join("");
}
function scriptList(dirs) {
  return dirs.map(dir => `<div class="sgroup"><h3>${dir}/</h3>${D.scripts[dir].map(s =>
    `<div class="srow"><a href="${s.url}">${esc(s.name)}</a><span>${esc(s.about)}</span></div>`).join("")}</div>`).join("");
}

const tick = () => $("#st-clock").textContent = new Date().toTimeString().slice(0, 5);
tick(); setInterval(tick, 30000);

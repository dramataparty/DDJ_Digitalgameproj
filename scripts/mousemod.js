/* ============================================================
    UNIVERSAL MOUSE TOOLS CONTROLLER
    Modes:
    - normal : default browser behavior
    - drag   : drag ANY element
    - hammer : push element deeper (lower z-index)
    - pliers : pull element forward (higher z-index)

    Drop this file into ANY PHP / HTML project:
    <script src="mouseTools.js"></script>

    No dependencies
    No libraries
    Pure vanilla JS
   ============================================================ */

(function () {
  let mouseMode = "normal";
  let dragging = null;
  let offsetX = 0;
  let offsetY = 0;

  /* ============================================================
      CREATE BROWSER-EXTENSION STYLE TOOL DROPDOWN
     ============================================================ */
  function createToolsMenu() {
    const menu = document.createElement("div");
    menu.id = "mouse-tools-menu";
    menu.style.position = "fixed";
    menu.style.top = "12px";
    menu.style.right = "12px";
    menu.style.zIndex = "999999";
    menu.style.fontFamily = "monospace";
    menu.style.color = "#0f0";

    menu.innerHTML = `
      <details style="
        width: 180px;
        background:#111;
        border:1px solid #0f0;
        box-shadow:0 0 6px #0f0;
      ">
        <summary style="
          cursor:pointer;
          padding:8px;
          font-weight:bold;
          display:flex;
          justify-content:space-between;
          align-items:center;
          list-style:none;
        ">
          🛠️ Tools
          <span style="opacity:0.6;font-size:10px;">▼</span>
        </summary>

        <div style="border-top:1px solid #0f0;">
          <button data-mode="normal"  class="tool-btn">🖱️ Normal Mode</button>
          <button data-mode="drag"    class="tool-btn">✋ Drag Mode</button>
          <button data-mode="hammer"  class="tool-btn">🔨 Hammer (Push)</button>
          <button data-mode="pliers"  class="tool-btn">🔧 Pliers (Pull)</button>
        </div>
      </details>

      <div id="mouse-tools-status" style="
        margin-top:6px;
        background:#000;
        border:1px solid #0f0;
        padding:4px;
        font-size:12px;
        text-align:center;
      ">
        Active Mode: normal
      </div>
    `;

    document.body.appendChild(menu);

    // Style buttons
    const buttons = menu.querySelectorAll(".tool-btn");
    buttons.forEach((btn) => {
      btn.style.width = "100%";
      btn.style.background = "transparent";
      btn.style.color = "#0f0";
      btn.style.border = "none";
      btn.style.textAlign = "left";
      btn.style.padding = "8px";
      btn.style.cursor = "pointer";
      btn.style.fontSize = "13px";

      btn.onmouseover = () => (btn.style.background = "rgba(0,255,0,0.15)");
      btn.onmouseout = () => (btn.style.background = "transparent");

      btn.onclick = () => setMode(btn.dataset.mode);
    });
  }

  /* ============================================================
      MODE SWITCHER
     ============================================================ */
  function setMode(mode) {
    mouseMode = mode;
    document.getElementById("mouse-tools-status").innerHTML =
      "Active Mode: <b>" + mode + "</b>";

    // Cancel active dragging if switching away
    dragging = null;
  }

  /* ============================================================
      UNIVERSAL DRAG MODE
     ============================================================ */
  function mousedownDrag(e) {
    if (mouseMode !== "drag") return;
    if (e.button !== 0) return; // left click only

    dragging = e.target;

    const rect = dragging.getBoundingClientRect();
    offsetX = e.clientX - rect.left;
    offsetY = e.clientY - rect.top;

    dragging.style.position = "absolute";
    dragging.style.zIndex = dragging.style.zIndex || 5;
  }

  function mousemoveDrag(e) {
    if (mouseMode !== "drag") return;
    if (!dragging) return;

    dragging.style.left = `${e.clientX - offsetX}px`;
    dragging.style.top = `${e.clientY - offsetY}px`;
  }

  function mouseupDrag() {
    dragging = null;
  }

  /* ============================================================
      HAMMER & PLIERS (DEPTH PUZZLE MODES)
     ============================================================ */
  function clickDepth(e) {
    if (mouseMode !== "hammer" && mouseMode !== "pliers") return;

    const el = e.target;

    // make sure z-index applies
    const style = window.getComputedStyle(el);
    if (style.position === "static") el.style.position = "relative";

    let current = parseInt(el.style.zIndex || "0");

    if (mouseMode === "hammer") el.style.zIndex = current - 10;
    if (mouseMode === "pliers") el.style.zIndex = current + 10;
  }

  /* ============================================================
      EVENT LISTENERS
     ============================================================ */
  document.addEventListener("mousedown", mousedownDrag);
  document.addEventListener("mousemove", mousemoveDrag);
  document.addEventListener("mouseup", mouseupDrag);
  document.addEventListener("mousedown", clickDepth);

  /* ============================================================
      INIT UI
     ============================================================ */
  window.addEventListener("load", () => {
    createToolsMenu();
  });
})();

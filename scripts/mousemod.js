/* ============================================================
    UNIVERSAL MOUSE TOOLS CONTROLLER
    Modes:
    - normal : default browser behavior
    - drag   : drag ANY element
    - hammer : push element deeper (lower z-index)
    - pliers : pull element forward (higher z-index)
    possible extra tools for extra levels:
    - flashlight (increase gamma to reveal hidden elements)
    - scissors (cut element apart into pieces)
    - staple gun (attack cut pieces back together)

    Drop this file into ANY PHP / HTML project:
    <script src="mouseTools.js"></script>

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
    menu.style.bottom = "20px";   // ⬅ bottom-right
    menu.style.right = "20px";
    menu.style.zIndex = "999999";
    menu.style.fontFamily = "monospace";
    menu.style.color = "#0f0";

    menu.style.pointerEvents = "auto";

    menu.innerHTML = `
      <div style="
        width: 220px;
        background:#000;
        border:2px solid #0f0;
        border-radius:8px;
        box-shadow:0 0 12px #0f0;
        padding:10px;
      ">
        <div style="
          font-size:16px;
          font-weight:bold;
          margin-bottom:8px;
          text-align:center;
          text-shadow:0 0 6px #0f0;
        ">
          🛠️ Mouse Tools
        </div>

        <div style="display:flex; flex-direction:column; gap:8px;">
          <button data-mode="normal" class="tool-btn" style="
            padding:10px;
            font-size:14px;
            background:#030;
            border:1px solid #0f0;
            color:#0f0;
            cursor:pointer;
            border-radius:4px;
          ">🖱️ Normal Mode</button>

          <button data-mode="drag" class="tool-btn" style="
            padding:10px;
            font-size:14px;
            background:#030;
            border:1px solid #0f0;
            color:#0f0;
            cursor:pointer;
            border-radius:4px;
          ">✋ Drag Mode</button>

          <button data-mode="hammer" class="tool-btn" style="
            padding:10px;
            font-size:14px;
            background:#300;
            border:1px solid #f00;
            color:#f00;
            cursor:pointer;
            border-radius:4px;
          ">🔨 Hammer (Push)</button>

          <button data-mode="pliers" class="tool-btn" style="
            padding:10px;
            font-size:14px;
            background:#003;
            border:1px solid #09f;
            color:#09f;
            cursor:pointer;
            border-radius:4px;
          ">🔧 Pliers (Pull)</button>
        </div>

        <div id="mouse-tools-status" style="
          margin-top:12px;
          background:#020;
          border:1px solid #0f0;
          padding:6px;
          font-size:13px;
          text-align:center;
          border-radius:4px;
        ">
          Active Mode: normal
        </div>
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

/* 
  mousemod.js
  -----------------------
  A modular mouse interaction system for PHP-based games.
  Modes:
    1. Flashlight - reveals hidden clues
    2. Hammer - breaks page elements
    3. Drag - lets the user move objects around
*/

(function() {
  let currentMode = 'flashlight'; // default (can be set via PHP or toggled in-game)
  let spotlight = null;
  let activeDrag = null;

  // --- Mode Controller ---
  function setMode(mode) {
    cleanupModes();
    currentMode = mode;
    console.log(`Mouse mode changed to: ${mode}`);

    switch (mode) {
      case 'flashlight':
        initFlashlight();
        break;
      case 'drag':
        initDrag();
        break;
      case 'hammer':
        initHammer();
        break;
    }

    // optional: send mode change to PHP backend
    fetch('update_mode.php', {
      method: 'POST',
      body: new URLSearchParams({ mode })
    });
  }

  // --- Flashlight Mode ---
  function initFlashlight() {
    spotlight = document.createElement('div');
    spotlight.id = 'flashlight';
    document.body.appendChild(spotlight);

    document.addEventListener('mousemove', moveFlashlight);
  }

  function moveFlashlight(e) {
    if (!spotlight) return;
    spotlight.style.left = e.clientX + 'px';
    spotlight.style.top = e.clientY + 'px';
  }

  // --- Drag Mode ---
  function initDrag() {
    document.querySelectorAll('.draggable').forEach(el => {
      el.style.position = 'absolute';
      el.addEventListener('mousedown', dragStart);
    });
    document.addEventListener('mouseup', dragEnd);
    document.addEventListener('mousemove', dragMove);
  }

  function dragStart(e) {
    activeDrag = e.target;
    activeDrag.classList.add('dragging');
  }

  function dragEnd() {
    if (activeDrag) activeDrag.classList.remove('dragging');
    activeDrag = null;
  }

  function dragMove(e) {
    if (activeDrag) {
      activeDrag.style.left = e.pageX - activeDrag.offsetWidth / 2 + 'px';
      activeDrag.style.top = e.pageY - activeDrag.offsetHeight / 2 + 'px';
    }
  }

  // --- Hammer Mode ---
  function initHammer() {
    document.addEventListener('click', hammerHit);
  }

  function hammerHit(e) {
    if (currentMode !== 'hammer') return;

    const target = e.target;
    if (target.classList.contains('breakable')) {
      target.classList.add('broken');
      // Optional: notify PHP
      fetch('update_progress.php', {
        method: 'POST',
        body: new URLSearchParams({ action: 'break', id: target.id })
      });
    }
  }

  // --- Cleanup when switching modes ---
  function cleanupModes() {
    // flashlight cleanup
    if (spotlight) {
      spotlight.remove();
      spotlight = null;
    }
    document.removeEventListener('mousemove', moveFlashlight);
    document.removeEventListener('click', hammerHit);
    document.removeEventListener('mouseup', dragEnd);
    document.removeEventListener('mousemove', dragMove);
    document.querySelectorAll('.draggable').forEach(el => {
      el.removeEventListener('mousedown', dragStart);
    });
  }

  // --- Public API ---
  window.mousemod = {
    setMode,
    getMode: () => currentMode
  };
})();

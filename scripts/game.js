// game.js

// --------------
// THEME TOGGLE
// --------------
const toggleThemeBtn = document.getElementById('toggleTheme');
if (toggleThemeBtn) {
  toggleThemeBtn.addEventListener('click', () => {
    const currentTheme = document.documentElement.dataset.theme;
    const newTheme = currentTheme === 'light' ? 'dark' : 'light';
    document.cookie = `theme=${newTheme}; path=/; max-age=31536000`; // 1 year
    location.reload(); // reload to apply theme (PHP reads cookie)
  });
}

// --------------
// LOCAL STORAGE SAVE SYSTEM
// --------------
const saveKey = 'hypnosurf_save';

// Default player data
const defaultSave = {
  inventory: [],
  visited: []
};

// Load save file or create a new one
let saveData = JSON.parse(localStorage.getItem(saveKey)) || defaultSave;

// Record current page as visited
const currentPage = new URLSearchParams(window.location.search).get('page') || 'home';
if (!saveData.visited.includes(currentPage)) {
  saveData.visited.push(currentPage);
  localStorage.setItem(saveKey, JSON.stringify(saveData));
}

// Example inventory system
function addItem(item) {
  if (!saveData.inventory.includes(item)) {
    saveData.inventory.push(item);
    localStorage.setItem(saveKey, JSON.stringify(saveData));
    alert(`You picked up: ${item}`);
  }
}

// For debugging / dev: check save
console.log('Save data:', saveData);

// Example trigger: add an item when visiting test-level
if (currentPage === 'test-level') {
  addItem('Cool Badge');
}
// game.js

// ... existing theme + save logic from before ...

// MENU BUTTON HANDLERS
const newGameBtn = document.getElementById('newGame');
const loadGameBtn = document.getElementById('loadGame');
const settingsBtn = document.getElementById('settings');
const exitBtn = document.getElementById('exitGame');

if (newGameBtn) {
  newGameBtn.addEventListener('click', () => {
    // Clear progress and start fresh
    localStorage.removeItem('hypnosurf_save');
    window.location.href = '?page=test-level'; // start the first level
  });
}

if (loadGameBtn) {
  loadGameBtn.addEventListener('click', () => {
    const save = JSON.parse(localStorage.getItem('hypnosurf_save') || '{}');
    if (save.visited && save.visited.length > 0) {
      const last = save.visited[save.visited.length - 1];
      window.location.href = `?page=${last}`;
    } else {
      alert('No saved game found!');
    }
  });
}

if (settingsBtn) {
  settingsBtn.addEventListener('click', () => {
    alert('Settings menu coming soon!');
  });
}

if (exitBtn) {
  exitBtn.addEventListener('click', () => {
    window.close();
  });
}

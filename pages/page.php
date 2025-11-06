<?php
// templates/page.php
?>
<!DOCTYPE html>
<html data-theme="<?= htmlspecialchars($theme) ?>">
<head>
  <meta charset="UTF-8">
  <title><?= htmlspecialchars($page['title']) ?></title>
  <link rel="stylesheet" href="assets/style.css">
  <script defer src="assets/game.js"></script>
</head>
<body>
  <header>
    <h1><?= htmlspecialchars($page['title']) ?></h1>
    <nav>
      <a href="?page=home">Home</a>
      <button id="toggleTheme">Toggle Theme</button>
    </nav>
  </header>

  <main>
    <div class="content">
      <?= $page['content']['body'] ?>
    </div>
  </main>

  <footer>
    <small>Last visited: <?= htmlspecialchars($_COOKIE['last_page'] ?? 'none') ?></small>
  </footer>
</body>
</html>

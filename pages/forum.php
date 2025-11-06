<?php
// pages/forum.php

// Get current page slug or default
$slug = $_GET['page'] ?? 'forum';

// Load level data
$levels = json_decode(file_get_contents(__DIR__ . '/levels/levels.json'), true);

// Check if level exists
if (!isset($levels[$slug])) {
    http_response_code(404);
    echo "<h1>404 Not Found</h1><p>No such page: $slug</p>";
    exit;
}

// Get page data
$page = $levels[$slug];

// Include chosen template
include __DIR__ . "/templates/{$page['template']}.php";

// Forum base template
if ($page['template'] === 'forum') {
    // Forum page template
}
?>
<!DOCTYPE html>
<html data-theme="<?= htmlspecialchars($theme) ?>">
<head>
  <meta charset="UTF-8">
  <title><?= htmlspecialchars($page['title']) ?></title>
  <link rel="stylesheet" href="assets/style.css">
</head>
<body>
  <header>
    <h1><?= htmlspecialchars($page['title']) ?></h1>
  </header>

  <main>
    <div class="content">
      <?php foreach ($page['content']['posts'] as $post): ?>
        <article>
          <h2><?= htmlspecialchars($post['title']) ?></h2>
          <p><?= $post['body'] ?></p>
        </article>
      <?php endforeach; ?>
    </div>
  </main>

  <footer>
    <small>Last visited: <?= htmlspecialchars($_COOKIE['last_page'] ?? 'none') ?></small>
  </footer>
</body>
</html>

<?php

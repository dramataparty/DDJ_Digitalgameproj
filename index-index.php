<?php
// index.php

// Get current page slug or default
$slug = $_GET['page'] ?? 'home';

// Load level data
$levels = json_decode(file_get_contents(__DIR__ . '/levels/levels.json'), true);

// Check if level exists
if (!isset($levels[$slug])) {
    http_response_code(404);
    echo "<h1>404 Not Found</h1><p>No such page: $slug</p>";
    exit;
}

// Save "last visited page" cookie for nostalgia
setcookie('last_page', $slug, time() + (86400 * 30), '/');

// Example: Theme preference cookie (defaults to light)
$theme = $_COOKIE['theme'] ?? 'light';

// Get page data
$page = $levels[$slug];

// Include chosen template
include __DIR__ . "/templates/{$page['template']}.php";

<?php
session_start();
$current_mode = $_SESSION['mouse_mode'] ?? 'flashlight';
?>
<!DOCTYPE html>
<html>
<head>
  <link rel="stylesheet" href="mousemod.css">
</head>
<body>
  <div id="game">
    <div class="draggable" style="top:100px;left:100px;">🧩 Drag Me</div>
    <div class="breakable" id="vase" style="top:200px;left:300px;">💠 Vase</div>
  </div>

  <script src="mousemod.js"></script>
  <script>
    mousemod.setMode("<?php echo $current_mode; ?>");

    // Example toggle buttons (optional)
    document.addEventListener('keydown', e => {
      if (e.key === '1') mousemod.setMode('flashlight');
      if (e.key === '2') mousemod.setMode('drag');
      if (e.key === '3') mousemod.setMode('hammer');
    });
  </script>
</body>
</html>

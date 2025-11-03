<?php
echo "<h1> THE FORUMS </h1>"; ?>

<div class="button-container">
    <button onclick="window.location.href='newgame.php'"> New Game </button>
    <button onclick="window.location.href='loadgame.php'"> Load Game </button>
    <button onclick="window.location.href='settings.php'"> Settings </button>
    <button onclick="window.close()"> Exit </button>
</div>

<style>
    .button-container {
        display: flex;
        flex-direction: column;
        align-items: center;
    }
    .button-container button {
        margin-bottom: 10px;
    }
</style>


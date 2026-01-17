extends Node2D

@export var grid_width := 5
@export var grid_height := 5
@export var cell_size := 64

@export var cell_scene: PackedScene
@export var total_bombs := 3

var bomb_cells: Array = []
var solved_count := 0

func _ready():
	spawn_grid()

func puzzle_solved():
	print("All bombs buried!")
	# TODO: Trigger next level, animation, sound, etc.

func spawn_grid():
	bomb_cells.clear()
	solved_count = 0

	var bomb_positions := [
		Vector2i(1, 2),
		Vector2i(3, 1),
		Vector2i(4, 3),
	]

	for y in range(grid_height):
		for x in range(grid_width):
			var cell = cell_scene.instantiate()
			cell.position = Vector2(x, y) * cell_size
			$Cells.add_child(cell)

			if Vector2i(x, y) in bomb_positions:
				cell.is_bomb_target = true
				bomb_cells.append(cell)

			cell.bomb_placed.connect(_on_bomb_placed)

func _on_bomb_placed(cell):
	if cell in bomb_cells:
		solved_count += 1
		if solved_count == total_bombs:
			puzzle_solved()

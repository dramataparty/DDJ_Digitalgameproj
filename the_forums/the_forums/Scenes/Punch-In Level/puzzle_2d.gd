extends Node2D

@export var grid_width := 5
@export var grid_height := 5
@export var cell_size := 64

@export var cell_scene: PackedScene
@export var total_bombs := 3

var bomb_cells := []
var solved_count := 0

func puzzle_solved():
	print("All bombs buried!")
	# Trigger next level, animation, sound, etc.

func _ready():
	spawn_grid()

func spawn_grid():
	# Hard-coded bomb positions for puzzle clarity
	var bomb_positions := [
		Vector2i(1, 2),
		Vector2i(3, 1),
		Vector2i(4, 3)
	]

	for y in range(grid_height):
		for x in range(grid_width):
			var cell = cell_scene.instantiate()
			cell.position = Vector2(x, y) * cell_size
			$Cells.add_child(cell)

			if Vector2i(x, y) in bomb_positions:
				cell.is_bomb_target = true
				bomb_cells.append(cell)


func check_puzzle_progress():
	solved_count = 0
	for cell in bomb_cells:
		if cell.occupied:
			solved_count += 1

	if solved_count == total_bombs:
		puzzle_solved()

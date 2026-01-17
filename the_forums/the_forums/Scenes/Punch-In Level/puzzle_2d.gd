extends Node2D

@export var total_bombs := 3

# Optional: which cells (by name) are bomb targets
@export var bomb_cell_names: Array[StringName] = [
	"Cell_1_2",
	"Cell_3_1",
	"Cell_4_3",
]

@export var hint_cell_names: Array[StringName] = [
	"Cell_1_1",
	"Cell_1_3",
	"Cell_2_2",
	"Cell_2_1",
	"Cell_4_1",
	"Cell_3_2",
	"Cell_3_3",
	"Cell_4_2",
	"Cell_4_4",
]

var bomb_cells: Array = []
var hint_cells: Array = []
var solved_count := 0

# Preload the hint texture once
const HINT_TEXTURE := preload("res://assets/Minesweeper_1.svg.png")

func _ready():
	_setup_cells()

func _setup_cells():
	bomb_cells.clear()
	hint_cells.clear()
	solved_count = 0

	# Collect all GridCell children under "Cells"
	for cell in $Cells.get_children():
		if not cell.has_method("can_accept_object"):
			continue

		# Reset any previous state on the cell (optional but safe)
		if "is_bomb_target" in cell:
			cell.is_bomb_target = false
		if "is_hint_cell" in cell:
			cell.is_hint_cell = false

		# Mark bomb targets by name
		if StringName(cell.name) in bomb_cell_names:
			cell.is_bomb_target = true
			bomb_cells.append(cell)

		# Mark hint cells by name
		if StringName(cell.name) in hint_cell_names:
			_mark_hint_cell(cell)

		# Connect the signal once
		var callable := Callable(self, "_on_bomb_placed")
		if not cell.bomb_placed.is_connected(callable):
			cell.bomb_placed.connect(callable)

func _mark_hint_cell(cell):
	if "is_hint_cell" in cell:
		cell.is_hint_cell = true
		hint_cells.append(cell)

		# Replace cell sprite with hint texture
		if cell.has_node("Sprite2D"):
			var sprite: Sprite2D = cell.get_node("Sprite2D")
			sprite.texture = HINT_TEXTURE

			# --- SCALE SPRITE TO MATCH CELL SIZE ---
			# Example: get cell size from a RectangleShape2D on the cell
			if cell.has_node("CollisionShape2D"):
				var collision_shape: CollisionShape2D = cell.get_node("CollisionShape2D")
				var shape: RectangleShape2D = collision_shape.shape as RectangleShape2D
				if shape:
					var cell_size: Vector2 = shape.extents * 2.0
					var tex_size: Vector2 = sprite.texture.get_size()
					if tex_size.x > 0 and tex_size.y > 0:
						sprite.scale = cell_size / tex_size

		elif cell is Sprite2D:
			cell.texture = HINT_TEXTURE
			# If the cell itself is the sprite, you can apply the same scaling logic here


func _on_bomb_placed(cell):
	if cell in bomb_cells:
		solved_count += 1
		if solved_count == total_bombs:
			puzzle_solved()

func puzzle_solved():
	print("All bombs buried!")
	# TODO: trigger animation / next level / etc.

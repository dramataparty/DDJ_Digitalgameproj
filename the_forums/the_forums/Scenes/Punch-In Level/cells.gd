extends Node2D

@export var cell_size := Vector2.ZERO

func _ready():
	organize_cells()


func organize_cells():
	var cells := []

	# Collect valid cells
	for child in get_children():
		if child is Area2D and child.name.begins_with("Cell_"):
			cells.append(child)

	if cells.is_empty():
		return

	# Auto-detect cell size if not set
	if cell_size == Vector2.ZERO:
		cell_size = detect_cell_size(cells[0])

	# Position cells
	for cell in cells:
		var parts = cell.name.split("_")
		if parts.size() != 3:
			continue

		var x = int(parts[1])
		var y = int(parts[2])

		cell.position = Vector2(
			x * cell_size.x,
			y * cell_size.y
		)


func detect_cell_size(cell: Area2D) -> Vector2:
	# Try CollisionShape2D first
	for child in cell.get_children():
		if child is CollisionShape2D and child.shape:
			var rect = child.shape.get_rect()
			return rect.size

	# Try Sprite2D
	for child in cell.get_children():
		if child is Sprite2D and child.texture:
			return child.texture.get_size()

	# Fallback
	return Vector2(32, 32)

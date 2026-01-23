extends Node2D

@onready var level_root := get_parent()
@onready var wrong_label := level_root.get_node("WrongLabel")
@onready var gold_star_1 := level_root.get_node("GoldStar")
@onready var gold_star_2 := level_root.get_node("GoldStar2")
@onready var gold_star_3 := level_root.get_node("GoldStar3")

@export var total_bombs := 3

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

const HINT_TEXTURE := preload("res://assets/Minesweeper_1.svg.png")

func _ready():
	_setup_cells()

func _setup_cells():
	bomb_cells.clear()
	hint_cells.clear()
	solved_count = 0

	for cell in $Cells.get_children():
		# Mark bomb targets by name
		if StringName(cell.name) in bomb_cell_names:
			cell.is_bomb_target = true
			bomb_cells.append(cell)

		# Mark hint cells by name
		if StringName(cell.name) in hint_cell_names:
			_mark_hint_cell(cell)

		var callable := Callable(self, "_on_bomb_placed")
		if not cell.bomb_placed.is_connected(callable):
			cell.bomb_placed.connect(callable)

func _mark_hint_cell(cell):
	# Property exists on GridCell script; no need for string check
	cell.is_hint_cell = true
	hint_cells.append(cell)

	# Replace cell sprite with hint texture
	if cell.has_node("Sprite2D"):
		var sprite: Sprite2D = cell.get_node("Sprite2D")
		sprite.texture = HINT_TEXTURE

		# Scale sprite to match collision shape size
		if cell.has_node("CollisionShape2D"):
			var collision_shape: CollisionShape2D = cell.get_node("CollisionShape2D")
			var shape: RectangleShape2D = collision_shape.shape as RectangleShape2D
			if shape:
				var cell_size: Vector2 = shape.extents * 2.0
				var tex_size: Vector2 = sprite.texture.get_size()
				if tex_size.x > 0 and tex_size.y > 0:
					sprite.scale = cell_size / tex_size

func _on_bomb_placed(cell):
	if cell.has_bomb and not cell.is_bomb_target:
		_show_wrong_feedback()

	_recalculate_solution()

func _recalculate_solution():
	solved_count = 0
	for cell in bomb_cells:
		if cell.has_bomb and cell.bomb_is_buried:
			solved_count += 1
		elif cell.has_bomb and not cell.bomb_is_buried:
			_show_bury_hint()

	_update_stars()


func _update_stars():
	gold_star_1.visible = solved_count >= 1
	gold_star_2.visible = solved_count >= 2
	gold_star_3.visible = solved_count >= 3
	if(solved_count >= 3):
		$"../nextButton".visible = true

func _show_wrong_feedback():
	#print("Wrong answer")
	#wrong_label.text = "Wrong cell!"
	#wrong_label.visible = true
	#await get_tree().create_timer(1.0).timeout
	#wrong_label.visible = false
	pass

func _show_bury_hint():
	print("Bombs in Minesweeper are buried!")
	wrong_label.text = "Bombs in Minesweeper are buried!"
	wrong_label.visible = true
	await get_tree().create_timer(1.0).timeout
	wrong_label.visible = false

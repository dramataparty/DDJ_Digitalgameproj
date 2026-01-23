extends Node2D

signal puzzle_complete

@onready var pizza: Sprite2D = $PizzaSlice
@onready var peperoner: Sprite2D = $Peperoner
@onready var musroom: Sprite2D = $Musroom


var completed := false


func _ready():
	print("Pizza puzzle ready.")
	print("Pizza:", pizza, "Peperoner:", peperoner, "Musroom:", musroom)
	set_process(true)


func _process(_delta):
	if completed:
		return

	if _check_puzzle():
		_complete_puzzle()


func _check_puzzle() -> bool:
	if not pizza or not peperoner or not musroom:
		return false

	# 1) Pizza must be cut
	if not pizza.is_split:
		return false

	# 2) Toppings must be on top
	if peperoner.z_index <= pizza.z_index:
		return false

	if musroom.z_index <= pizza.z_index:
		return false

	# 3) Must overlap pizza
	if not peperoner.get_global_rect().intersects(pizza.get_global_rect()):
		return false

	if not musroom.get_global_rect().intersects(pizza.get_global_rect()):
		return false

	return true


func _complete_puzzle():
	if completed:
		return

	completed = true
	print("🍕 Puzzle complete! Pizza is assembled.")
	emit_signal("puzzle_complete")

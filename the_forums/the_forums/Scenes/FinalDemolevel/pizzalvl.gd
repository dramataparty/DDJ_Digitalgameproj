extends Node2D

signal puzzle_complete

@onready var pizza: Sprite2D = $PizzaSlice
@onready var peperoner: Sprite2D = $Peperoner
@onready var musroom: Sprite2D = $Musroom
@onready var hint_label: Label = $HintLabel

var completed := false


func _ready():
	print("Pizza puzzle ready.")
	print("Pizza:", pizza, "Peperoner:", peperoner, "Musroom:", musroom)
	set_process(true)
	_hint_populate()


func _process(_delta):
	if completed:
		return

	if _check_puzzle():
		_complete_puzzle()


func _check_puzzle() -> bool:
	if not pizza or not peperoner or not musroom:
		return false

	# --- 1) Everything must be split ---
	if not pizza.is_split:
		return false

	if not peperoner.is_split:
		return false

	if not musroom.is_split:
		return false

	# --- 2) Gather pizza halves ---
	var pizza_halves := _get_halves(pizza)
	if pizza_halves.size() != 2:
		return false

	# --- 3) Each topping must have halves ---
	var pep_halves := _get_halves(peperoner)
	var mush_halves := _get_halves(musroom)

	if pep_halves.size() != 2 or mush_halves.size() != 2:
		return false

	# --- 4) Each pizza half must contain one of each topping half ---
	for half in pizza_halves:
		if not _has_matching_topping(half, pep_halves):
			return false
		if not _has_matching_topping(half, mush_halves):
			return false

	# --- 5) Toppings must be above pizza ---
	for p in pep_halves + mush_halves:
		if p.z_index <= pizza.z_index:
			return false

	return true


func _get_halves(item: Sprite2D) -> Array:
	var result := []

	if item.is_split:
		result.append(item)

	for c in item.get_children():
		if c is Sprite2D and c.is_split:
			result.append(c)
	return result


func _has_matching_topping(pizza_half: Sprite2D, topping_halves: Array) -> bool:
	for t in topping_halves:
		# must be stapled (parented) to the pizza half
		if t.get_parent() == pizza_half:
			return true
	return false


func _hint_populate():
	if not hint_label:
		return

	hint_label.text = \
		"Cut the pizza and toppings.\n" + \
		"Staple each topping half onto each pizza half.\n" + \
		"Make sure toppings are above the pizza."


func _complete_puzzle():
	if completed:
		return

	completed = true
	print("🍕 Puzzle complete! Pizza is assembled.")
	emit_signal("puzzle_complete")

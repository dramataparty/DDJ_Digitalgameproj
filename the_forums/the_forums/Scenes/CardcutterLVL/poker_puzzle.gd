extends Node2D

signal puzzle_complete

@onready var pizza: Sprite2D = $PizzaSlice
@onready var peperoner: Sprite2D = $Peperoner
@onready var musroom: Sprite2D = $Musroom
@onready var hint_label: Label = $HintLabel

var completed := false


func _ready():
	print("Pizza puzzle ready.")
	set_process(true)
	_update_hint()


func _process(_delta):
	if completed:
		return

	_update_hint()

	if _check_puzzle():
		_complete_puzzle()


# ---------------------------------------------------
# PUZZLE CHECK
# ---------------------------------------------------

func _check_puzzle() -> bool:
	if not pizza or not peperoner or not musroom:
		return false

	# 1) Must be split
	if not pizza.is_split:
		return false
	if not peperoner.is_split:
		return false
	if not musroom.is_split:
		return false

	var pizza_halves := _get_halves(pizza)
	var pep_halves := _get_halves(peperoner)
	var mush_halves := _get_halves(musroom)

	# 2) Must have exactly two halves
	if pizza_halves.size() != 2:
		return false
	if pep_halves.size() != 2:
		return false
	if mush_halves.size() != 2:
		return false

	# 3) Each pizza half must have one topping of each
	for half in pizza_halves:
		if not _has_matching_topping(half, pep_halves):
			return false
		if not _has_matching_topping(half, mush_halves):
			return false

	# 4) Toppings above pizza
	for p in pep_halves + mush_halves:
		if p.z_index <= pizza.z_index:
			return false

	return true


# ---------------------------------------------------
# HELPERS
# ---------------------------------------------------

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
		if t.get_parent() == pizza_half:
			return true
	return false


# ---------------------------------------------------
# DYNAMIC HINT SYSTEM
# ---------------------------------------------------

func _update_hint():
	if not hint_label:
		return

	if not pizza.is_split:
		hint_label.text = "Cut the pizza."
		return

	if not peperoner.is_split or not musroom.is_split:
		hint_label.text = "Cut the toppings."
		return

	var pizza_halves := _get_halves(pizza)
	var pep_halves := _get_halves(peperoner)
	var mush_halves := _get_halves(musroom)

	if pizza_halves.size() != 2:
		hint_label.text = "Make two pizza slices."
		return

	if pep_halves.size() != 2 or mush_halves.size() != 2:
		hint_label.text = "Each topping needs two halves."
		return

	for half in pizza_halves:
		if not _has_matching_topping(half, pep_halves) \
		or not _has_matching_topping(half, mush_halves):
			hint_label.text = "Attach one of each topping to every slice."
			return

	for p in pep_halves + mush_halves:
		if p.z_index <= pizza.z_index:
			hint_label.text = "Put the toppings on top of the pizza."
			return

	hint_label.text = "Looks good…"


# ---------------------------------------------------
# COMPLETE
# ---------------------------------------------------

func _complete_puzzle():
	if completed:
		return

	completed = true
	hint_label.text = "🍕 Pizza complete!"
	print("🍕 Puzzle complete! Pizza is assembled.")
	emit_signal("puzzle_complete")

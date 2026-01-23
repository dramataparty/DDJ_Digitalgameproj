extends Node2D

signal puzzle_complete

var completed: bool = false

@onready var pizza: Sprite2D = $PizzaSlice
@onready var peperoner: Sprite2D = $Peperoner
@onready var peperoner2: Sprite2D = $Peperoner2
@onready var musroom: Sprite2D = $Musroom
@onready var musroom2: Sprite2D = $Musroom2
@onready var hint_label: Label = $HintLabel

func _ready():
	peperoner.stapled_to.connect(_on_topping_moved)
	peperoner2.stapled_to.connect(_on_topping_moved)
	musroom.stapled_to.connect(_on_topping_moved)
	musroom2.stapled_to.connect(_on_topping_moved)
	update_hints()

func _on_topping_moved(_other: Sprite2D):
	await get_tree().process_frame
	update_hints()

func _complete_puzzle() -> void:
	if completed:
		return

	completed = true
	print("✅ Congratulations! Puzzle completed!")
	puzzle_complete.emit()

func _process(_delta):
	if completed:
		return
	
	var has_pep := _is_topping_over_pizza(peperoner) or _is_topping_over_pizza(peperoner2)
	var has_mush := _is_topping_over_pizza(musroom) or _is_topping_over_pizza(musroom2)
	
	if has_pep and has_mush:
		_complete_puzzle()

func _is_topping_over_pizza(topping: Sprite2D) -> bool:
	var pizza_rect: Rect2= pizza.get_global_rect()
	var topping_rect  :Rect2= topping.get_global_rect()
	return pizza_rect.intersects(topping_rect, true) and topping.z_index > pizza.z_index

func update_hints():
	var pep_status := "good" if _is_topping_over_pizza(peperoner) or _is_topping_over_pizza(peperoner2) else "none"
	var mush_status := "good" if _is_topping_over_pizza(musroom) or _is_topping_over_pizza(musroom2) else "none"
	
	match [pep_status, mush_status]:
		["good", "good"]:
			hint_label.text = "Pizza complete!"
		["good", "none"], ["none", "good"]:
			hint_label.text = "One more topping needed!"
		_:
			hint_label.text = "Place peperoni and mushrooms on pizza."

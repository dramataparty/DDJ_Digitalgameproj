extends Node2D

signal puzzle_complete

@export var card1_path: NodePath
@export var card2_path: NodePath

@onready var card1: Sprite2D = get_node_or_null(card1_path)
@onready var card2: Sprite2D = get_node_or_null(card2_path)

var completed := false


func _ready():
	if card1:
		card1.stapled_to.connect(_on_card_stapled.bind(card1))
	if card2:
		card2.stapled_to.connect(_on_card_stapled.bind(card2))


func _on_card_stapled(other: Sprite2D, sender: Sprite2D) -> void:
	if completed:
		return

	if not other or not sender:
		return

	print("Puzzle saw staple:", sender.item_id, "→", other.item_id)

	if _is_correct_match(sender, other):
		_complete_puzzle()


func _is_correct_match(a: Sprite2D, b: Sprite2D) -> bool:
	return (
		a.item_id == "card_1_rh" and b.item_id == "card_2_lh"
	) or (
		a.item_id == "card_2_rh" and b.item_id == "card_1_lh"
	)


func _complete_puzzle() -> void:
	if completed:
		return
	completed = true
	print("Congratulations! Puzzle completed!")
	emit_signal("puzzle_complete")

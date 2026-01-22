extends Node2D

signal puzzle_complete

@export var card1_path: NodePath
@export var card2_path: NodePath
@export var item_connection_point: Node2D  # Optional: point where items should attach

@onready var card1: Sprite2D = get_node_or_null(card1_path)
@onready var card2: Sprite2D = get_node_or_null(card2_path)

var completed := false
	
func _ready():
	if card1:
		card1.connect("stapled_to", Callable(self, "_on_card_stapled"))
	if card2:
		card2.connect("stapled_to", Callable(self, "_on_card_stapled"))

func _on_card_stapled(other: Sprite2D):
	if completed:
		return

	# Check for the specific halves
	var c1_half = card1.item_id + "_half"
	var c2_half = card2.item_id + "_half"

	# Puzzle is complete if either combination is stapled
	if (other.item_id == c2_half and card1.item_id == c1_half) or \
	   (other.item_id == c1_half and card2.item_id == c2_half):
		_complete_puzzle()

func _complete_puzzle() -> void:
	if completed:
		return
	completed = true
	print("Congratulations! Puzzle completed!")
	emit_signal("puzzle_complete")

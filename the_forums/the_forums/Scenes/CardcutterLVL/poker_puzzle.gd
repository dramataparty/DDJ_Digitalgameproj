extends Node2D

signal puzzle_complete

@export var card1_path: NodePath
@export var card2_path: NodePath

@onready var pokerlabel: Label = $PokerLabel
@onready var card1: Sprite2D = get_node_or_null(card1_path)
@onready var card2: Sprite2D = get_node_or_null(card2_path)

@export var completed: bool = false
var correct_matches: int = 0

func _ready() -> void:
	# Register so cut pieces can find us
	add_to_group("puzzle")

	print("Puzzle ready. Card1:", card1, "Card2:", card2)

	# Connect originals (before cut)
	if card1 and card1.has_signal("stapled_to"):
		card1.stapled_to.connect(_on_card_stapled.bind(card1))

	if card2 and card2.has_signal("stapled_to"):
		card2.stapled_to.connect(_on_card_stapled.bind(card2))


# Called by Sprite pieces when stapled
func _on_card_stapled(other: Sprite2D, sender: Sprite2D) -> void:
	if completed:
		return

	if not other or not sender:
		return

	print("PUZZLE SIGNAL:", sender.item_id, "→", other.item_id)

	if _is_correct_match(sender, other):
		correct_matches += 1
		print("Correct matches:", correct_matches)

		if correct_matches >= 2:
			_complete_puzzle()


func _is_correct_match(a: Sprite2D, b: Sprite2D) -> bool:
	# Ensure they are actually attached
	if b.get_parent() != a and a.get_parent() != b:
		return false

	if (
		(a.item_id == "card_1_rh" and b.item_id == "card_2_lh") or (b.item_id == "card_1_rh" and a.item_id == "card_2_lh")
	) or (
		(a.item_id == "card_2_rh" and b.item_id == "card_1_lh") or (b.item_id == "card_2_rh" and a.item_id == "card_1_lh")
	):
		return true

	return false


func _complete_puzzle() -> void:
	if completed:
		return

	completed = true
	print("✅ Congratulations! Puzzle completed!")

	if pokerlabel:
		pokerlabel.text = "Five of a Kind!\nImpossible hand — You win anyway!"

	emit_signal("puzzle_complete")

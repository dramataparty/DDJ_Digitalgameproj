extends Node2D

@export var slot_scene: PackedScene
@export var profile_scene: PackedScene
@export var header_node_path: NodePath
@export var star_icon_path: NodePath     # Node to enable when puzzle solved

var slots = []         # Holds slot nodes
var profiles = []      # Holds spawned profile items

var required_order = ["B", "B", "R", "G"]   # The level’s target sequence

var color_to_letter = {
	"Blue": "B",
	"Red": "R",
	"Green": "G"
}

func _ready():
	_build_slots()
	_spawn_profiles()


# ============================================================
# CREATE SLOTS
# ============================================================
func _build_slots():
	var header = get_node(header_node_path)
	var header_rect = header.get_rect()
	var base_pos = header.global_position
	
	# Spacing for 4 slots
	var spacing = 120
	var start_x = base_pos.x - (spacing * 1.5)

	for i in range(required_order.size()):
		var slot = slot_scene.instantiate()
		add_child(slot)

		slot.global_position = Vector2(start_x + i * spacing, base_pos.y - 80)
		slot.get_node("Label").text = required_order[i]
		slot.slot_letter = required_order[i]   # Custom exported variable on slot

		slots.append(slot)

		# Connect signal
		if slot.has_signal("item_dropped"):
			slot.connect("item_dropped", Callable(self, "_on_item_dropped"))


# ============================================================
# SPAWN USER PROFILE PICTURES
# ============================================================
func _spawn_profiles():
	var start_pos = Vector2(200, 600)

	# Example set of users
	var users = [
		{"name": "Alex", "club": "Blue"},
		{"name": "Mara", "club": "Red"},
		{"name": "Liam", "club": "Blue"},
		{"name": "Sara", "club": "Green"},
	]

	var spacing = 180

	for i in range(users.size()):
		var p = profile_scene.instantiate()
		add_child(p)

		p.global_position = start_pos + Vector2(i * spacing, 0)
		p.club_color = users[i]["club"]
		p.item_id = users[i]["name"]

		profiles.append(p)


# ============================================================
# TRIGGERED WHEN AN ITEM IS DROPPED ON A SLOT
# ============================================================
func _on_item_dropped(slot, item):
	# Check color match → letter match
	var expected_letter = slot.slot_letter
	var item_letter = color_to_letter.get(item.club_color, "")

	if expected_letter == item_letter:
		# Mark slot as correct
		slot.set_correct(true)
	else:
		slot.set_correct(false)

	_check_puzzle_solved()


# ============================================================
# CHECK IF ALL SLOTS ARE CORRECT
# ============================================================
func _check_puzzle_solved():
	for slot in slots:
		if not slot.is_correct:
			return   # not yet solved

	# All solved → award star
	_award_star()


# ============================================================
# AWARD STAR
# ============================================================
func _award_star():
	var star = get_node(star_icon_path)
	star.visible = true
	print("⭐ Puzzle Completed! Star Awarded!")

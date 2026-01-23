extends Node2D

var score = 0

signal request_scene_change(new_scene_path: String)

@export var next_scene: String

func go_to_next_scene():
	emit_signal("request_scene_change", next_scene)

func _ready() -> void:
	$ScrollContainer/VBoxContainer/Control/Star.visible = false
	$ScrollContainer/VBoxContainer/Control/Star.active = true

func _on_receptor_activated(item_id: String) -> void: # jank as hell but we don't have time
	score += 10
	print(score)
	if (score >= 40):
		$ScrollContainer/VBoxContainer/Control/Star.visible = true
	$ScrollContainer/VBoxContainer/Control/Star.active = false
	if (score >= 50):
		# level transition
		print("level transition!")
		go_to_next_scene()

func _on_receptor_deactivated(item_id: String) -> void:
	score -= 10
	print(score)
	if (score < 40):
		$ScrollContainer/VBoxContainer/Control/Star.visible = false
	$ScrollContainer/VBoxContainer/Control/Star.active = true

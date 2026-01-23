extends Control

signal request_scene_change(new_scene_path: String)

@export var next_scene: String = "res://Scenes/tutorial_page.tscn"
@export var progression_options: int = 0

func go_to_next_scene():
	emit_signal("request_scene_change", next_scene)

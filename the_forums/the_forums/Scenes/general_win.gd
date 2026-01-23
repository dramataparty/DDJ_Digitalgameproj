extends Node2D

signal request_scene_change(new_scene_path: String)

@export var progression_options: int
@export var next_scene: String

func go_to_next_scene():
	emit_signal("request_scene_change", next_scene)

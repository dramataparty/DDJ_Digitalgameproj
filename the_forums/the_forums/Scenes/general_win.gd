extends Node2D

signal request_scene_change(new_scene_path: String)

func go_to_next_scene():
	emit_signal("request_scene_change", "res://Scenes/Win.tscn")

func _on_next_button_win(next_scene_path: String) -> void:
	go_to_next_scene()

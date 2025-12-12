extends Node2D

signal request_scene_change(new_scene_path: String)

func _on_next_button_win(next_scene_path: String) -> void:
	print("AAAA")
	emit_signal("request_scene_change", next_scene_path)


func _on_receptor_activated(item_id: String) -> void:
	emit_signal("request_scene_change", "res://Scenes/Sports/Sports.tscn")

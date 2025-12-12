extends Button
signal win(next_scene_path: String)

func _on_enter_pressed():
	emit_signal("win","res://Scenes/Sports/Sports.tscn")

func _on_pressed() -> void:
	emit_signal("win","res://Scenes/Sports/Sports.tscn")

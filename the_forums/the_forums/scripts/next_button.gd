extends Button
signal win(next_scene_path: String)

func _on_enter_pressed():
	print("AAAA")
	emit_signal("win","res://Scenes/Sports/Sports.tscn")

func _on_pressed() -> void:
	print("AAAA")
	emit_signal("win","res://Scenes/Sports/Sports.tscn")

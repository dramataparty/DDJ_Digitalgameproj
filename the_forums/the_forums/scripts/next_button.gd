extends Button

@export var target_node_path: NodePath


func _on_pressed() -> void:
		$"..".go_to_next_scene()

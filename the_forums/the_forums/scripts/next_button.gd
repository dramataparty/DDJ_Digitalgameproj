extends Button

@export var target_node_path: NodePath
@onready var target_node: Node = get_node_or_null(target_node_path)

func _on_pressed() -> void:
	$"..".go_to_next_scene()

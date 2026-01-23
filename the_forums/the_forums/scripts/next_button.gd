extends Button

@export var target_node_path: NodePath
@onready var target_node: Node = get_node_or_null(target_node_path)

func _on_pressed() -> void:
	if target_node and target_node.has_method("go_to_next_scene"):
		target_node.go_to_next_scene()

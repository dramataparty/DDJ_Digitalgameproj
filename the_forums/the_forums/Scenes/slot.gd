extends Node2D

@export var slot_letter : String = ""
var is_correct := false

signal item_dropped(slot, item)

func set_correct(value: bool):
	is_correct = value
	modulate = value ? Color(0,1,0,1) : Color(1,1,1,1)

func _on_Area2D_body_entered(body):
	if body is Sprite2D:
		emit_signal("item_dropped", self, body)

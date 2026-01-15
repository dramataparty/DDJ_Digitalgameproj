extends Area2D

@export var is_bomb_target := false
var occupied := false

func can_accept_object() -> bool:
	return is_bomb_target and not occupied

func accept_object(obj: Node2D):
	occupied = true
	obj.global_position = global_position
	obj.z_index = -1  # bury bomb under grid

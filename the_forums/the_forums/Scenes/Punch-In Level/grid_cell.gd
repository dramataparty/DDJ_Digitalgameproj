extends Area2D

signal bomb_placed(cell: Node)

@export var is_bomb_target := false
var occupied := false
var is_hint_cell:=false
func can_accept_object() -> bool:
	return is_bomb_target and not occupied

func accept_object(obj: Node2D):
	if occupied:
		return
	occupied = true
	obj.global_position = global_position
	obj.z_index = -1
	if is_bomb_target:
		bomb_placed.emit(self)

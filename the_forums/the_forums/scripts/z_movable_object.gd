extends Node

# Configuration
@export var min_z_index: int = -5
@export var max_z_index: int = 5
@export var step_amount: int = 1


var require_mode: bool = false 

func _input(event):

	if not event is InputEventMouseButton or not event.pressed:
		return

	var parent_sprite = get_parent()
	if not parent_sprite is Sprite2D:
		return

	if not parent_sprite.get_rect().has_point(parent_sprite.to_local(event.position)):
		return

	
	if require_mode and Mouse.get_mode() == Mouse.Mode.HAMMER_PLIERS:
		
		if Mouse.get_mode() != Mouse.Mode.HAND: 
			return

	match event.button_index :
		MOUSE_BUTTON_RIGHT:
			change_z_index(parent_sprite, step_amount)
			get_viewport().set_input_as_handled() # Prevents other events
			
		MOUSE_BUTTON_LEFT:
			change_z_index(parent_sprite, -step_amount)

func change_z_index(target: Sprite2D, amount: int):
	var new_index = target.z_index + amount
	target.z_index = clamp(new_index, min_z_index, max_z_index)
	print("Item ID: ", target.get("item_id"), " | New Z-Index: ", target.z_index)

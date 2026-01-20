extends Area2D

signal bomb_placed(cell: Area2D)

@export var is_bomb_target := false
var is_hint_cell := false
var bomb_is_buried := false
var has_bomb := false
var occupying_bomb: Sprite2D = null

@export var check_interval: float = 0.1  # How often to check (seconds)

var _check_timer: Timer

func _ready():
	_check_timer = Timer.new()
	_check_timer.wait_time = check_interval
	_check_timer.timeout.connect(_update_bomb_state)
	_check_timer.autostart = true
	add_child(_check_timer)

func _update_bomb_state():
	var previous_has_bomb = has_bomb
	var previous_buried = bomb_is_buried
	
	# Find overlapping bombs
	var overlapping_areas = get_overlapping_areas()
	occupying_bomb = null
	has_bomb = false
	bomb_is_buried = false
	
	for area in overlapping_areas:
		var bomb_sprite := area.get_parent() as Sprite2D
		if bomb_sprite != null:
			occupying_bomb = bomb_sprite
			has_bomb = true
			
			# Check if bomb is buried (z_index < cell z_index)
			if occupying_bomb.z_index < self.z_index:
				bomb_is_buried = true
			break  # Only track first overlapping bomb
	
	# Emit if state changed
	if previous_has_bomb != has_bomb or previous_buried != bomb_is_buried:
		bomb_placed.emit(self)

func _on_area_entered(area: Area2D) -> void:
	_update_bomb_state()

func _on_area_exited(area: Area2D) -> void:
	_update_bomb_state()

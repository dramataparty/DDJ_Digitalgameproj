extends Node


enum Mode { 
	NORMAL, 
	HAND, 
	HAMMER_PLIERS, 
	SCISSORS_STAPLERS}

signal mode_changed(new_mode: Mode)

var _mode: Mode = Mode.NORMAL : set = set_mode

func set_mode(m: Mode) -> void:
	if _mode == m:
		return
	_mode = m
	mode_changed.emit(m)

func get_mode() -> Mode:
	return _mode

extends OptionButton

@export var progress: int = 1


func _ready() -> void:
	update_state(progress)


func _on_item_selected(index: int) -> void:
	match index:
		0: Mouse.set_mode(Mouse.Mode.NORMAL)
		1: Mouse.set_mode(Mouse.Mode.HAND)
		2: Mouse.set_mode(Mouse.Mode.HAMMER_PLIERS)
		3: Mouse.set_mode(Mouse.Mode.SCISSORS)
		_: Mouse.set_mode(Mouse.Mode.NORMAL)


func update_state(state: int) -> void:
	progress = max(state, progress)
	set_item_disabled(2, progress < 2) # Hammer unlocks at 2
	set_item_disabled(3, progress < 3) # Scissors unlocks at 3

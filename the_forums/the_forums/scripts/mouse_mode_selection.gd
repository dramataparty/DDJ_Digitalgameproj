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
	for item in (self.item_count):
		self.set_item_disabled(item, (item >= progress))
	#if level 1 not completed, lock hammer_pliers
	#if level 2 not completed, lock scissors_staplers

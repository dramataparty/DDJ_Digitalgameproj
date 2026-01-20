extends OptionButton

func _on_item_selected(index):
	match index:
		0: Mouse.set_mode(Mouse.Mode.NORMAL)
		1: Mouse.set_mode(Mouse.Mode.HAND)
		2: Mouse.set_mode(Mouse.Mode.HAMMER_PLIERS)
		3: Mouse.set_mode(Mouse.Mode.SCISSORS_STAPLERS)
		_: print("nothing selected, but normal")

func _mode_progression_locker():
	pass
	#if level 1 not completed, lock hammer_pliers
	#if level 2 not completed, lock scissors_staplers

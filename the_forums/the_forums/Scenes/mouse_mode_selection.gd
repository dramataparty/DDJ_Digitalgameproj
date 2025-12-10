extends OptionButton

func _on_item_selected(index):
	match index:
		0: Mouse.set_mode(Mouse.Mode.NORMAL)
		1: Mouse.set_mode(Mouse.Mode.HAND)
		_: print("nothing selected, but normal")

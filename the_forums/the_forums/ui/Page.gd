extends Control
const Element = preload("res://ui/Element.tscn")

func _ready():
	# build a fake web page with 4 dummy blocks
	var colours = [Color.CORNFLOWER_BLUE, Color.DARK_GREEN, Color.ORANGE, Color.DARK_RED]
	for i in 4:
		var e = Element.instantiate()
		e.position = Vector2(80 + i*140, 100 + i*70)
		e.size = Vector2(120, 80)
		e.get_child(0).color = colours[i]   # ColorRect
		add_child(e)

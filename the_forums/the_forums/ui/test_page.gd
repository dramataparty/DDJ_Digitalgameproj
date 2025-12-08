extends Control
class_name TestPage

const Element  = preload("res://ui/Element.tscn")   # your existing scene


func _ready():
	# make the page big enough to scroll a little
	size = Vector2(1200, 800)
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	# 1) 3-stack for z-order testing (hammer / pliers)
	_make_stack()

	# 2) 5-block row for scissors / stapler
	_make_cut_row()

	# 3) large drop-zone to staple onto
	_make_drop_zone()

	# 4) legend label
	_make_legend()

# ---------- 1) z-stack --------------------------------------------------
func _make_stack():
	var colours = [Color.DARK_RED, Color.FOREST_GREEN, Color.STEEL_BLUE]
	var names   = ["Bottom", "Middle", "Top"]
	for i in 3:
		var e = Element.instantiate()
		e.name = "Stack_" + names[i]
		e.position = Vector2(100, 100 + i*20)   # overlaps on purpose
		e.size     = Vector2(180, 120)
		e.z_index  = i*10                       # easy to see changes
		e.get_child(0).color = colours[i]       # ColorRect child
		add_child(e)

# ---------- 2) cut-row --------------------------------------------------
func _make_cut_row():
	var y = 300
	for i in 5:
		var e = Element.instantiate()
		e.name = "CutBlock_" + str(i)
		e.position = Vector2(100 + i*140, y)
		e.size     = Vector2(120, 80)
		e.get_child(0).color = Color.from_hsv(i/5.0, 0.8, 0.9)
		add_child(e)

# ---------- 3) drop-zone -----------------------------------------------
func _make_drop_zone():
	var e = Element.instantiate()
	e.name = "DropZone"
	e.position = Vector2(100, 500)
	e.size     = Vector2(600, 200)
	e.draggable = false                       # keep it fixed
	e.get_child(0).color = Color(0.1,0.1,0.1,0.5)  # semi-dark
	# optional border
	var border = ReferenceRect.new()
	border.border_color = Color.WHITE
	border.border_width = 2.0
	border.anchors_preset = Control.PRESET_FULL_RECT
	e.add_child(border)
	add_child(e)

# ---------- 4) legend ---------------------------------------------------
func _make_legend():
	var lbl = Label.new()
	lbl.text = """
	TAB          – cycle mouse mode
	Hand         – drag any block
	Hammer       – bring forward (+Z)
	Pliers       – send backward (-Z)
	Scissors     – click a block to split it
	Stapler      – click a fragment to glue it under mouse
	"""
	lbl.position = Vector2(800, 100)
	lbl.size     = Vector2(350, 300)
	lbl.add_theme_font_size_override("font_size", 18)
	lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	add_child(lbl)

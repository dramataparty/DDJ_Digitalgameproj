extends Control

var start ="res://Scenes/StartScreen.tscn"
var tutorial = "res://Scenes/tutorial_page.tscn"
var sports = "res://Scenes/Sports/Sports.tscn"
var minesweep = "res://Scenes/Punch-In Level/OnlineMinesweeplvl.tscn"
var poker = "res://Scenes/CardcutterLVL/pklvl.tscn"
var pizza = "res://Scenes/FinalDemolevel/pizzalvl.tscn"

var history = []
var pointer = 0

func back():
	print(history)
	print(pointer)
	$"../Forward".visible = true
	match (pointer):
		0: pointer = 1
	if (pointer-1 <= 1):
		$"../Back".visible = false
	pointer = pointer-1
	load_webpage(history[pointer-1])
	
func forward():
	print(history)
	pointer = pointer + 1
	print(pointer)
	if(pointer >= history.size()):
		$"../Forward".visible = false
	if(pointer <= history.size()):
		$"../Back".visible = true
		load_webpage(history[min(pointer, history.size()-1)])

func new_page(page : String):
	history.slice(0, pointer)
	history.append(page)
	pointer = pointer + 1
	if (history.size() > 1):
		$"../Back".visible = true
	$"../Forward".visible = false
	load_webpage(page)

var current_page : Variant = null

var current_page_path : String = ""

func load_webpage(pager : String):
	var page = load(pager).instantiate()
	self.add_child(page)
	if (current_page != null):
		current_page.queue_free()
	current_page_path = pager
	current_page = page
	current_page.visible = false
	if current_page.has_signal("request_scene_change"):
		current_page.connect("request_scene_change", Callable(self, "_on_child_request_scene_change"))
	$"../OptionButton".update_state(max(current_page.progression_options, $"../OptionButton".item_count))
	$Timer.start(0.5)
		
func reload_webpage():
	load_webpage(current_page_path)

func _on_child_request_scene_change(page: String):
	if(pointer < history.size()) :
		if (page == history[pointer]):
			forward()
	else:
		new_page(page)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset_button"):
		reload_webpage()

func _ready():
	new_page(start)

func _on_timer_timeout() -> void:
	print(history)
	print(pointer)
	$Timer.stop()
	current_page.visible = true

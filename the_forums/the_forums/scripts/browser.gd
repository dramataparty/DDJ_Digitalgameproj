extends Control

var start = load("res://Scenes/StartScreen.tscn").instantiate()
var tutorial = load("res://Scenes/tutorial_page.tscn").instantiate()
var sports = load("res://Scenes/Sports/Sports.tscn").instantiate()
var minesweep = load("res://Scenes/Punch-In Level/OnlineMinesweeplvl.tscn").instantiate()
var poker = load("res://Scenes/CardcutterLVL/pklvl.tscn").instantiate()
var pizza = load("res://Scenes/FinalDemolevel/pizzalvl.tscn").instantiate()


var current_page : Variant = null

func load_webpage(page):
	print("aaa")
	self.add_child(page)
	current_page = page
	current_page.visible = false
	if current_page.has_signal("request_scene_change"):
		current_page.connect("request_scene_change", Callable(self, "_on_child_request_scene_change"))
	$"../OptionButton".update_state(max(current_page.progression_options, $"../OptionButton".item_count))
	$Timer.start(0.5)
		
func reload_webpage():
	load_webpage(current_page)

func _on_child_request_scene_change(new_scene_path: String):
	current_page.queue_free()
	var page = load(new_scene_path).instantiate()
	load_webpage(page)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reset_button"):
		reload_webpage()

func _ready():
	load_webpage(start)

func _on_timer_timeout() -> void:
	current_page.visible = true

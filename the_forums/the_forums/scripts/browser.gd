extends Control

var tutorial = load("res://Scenes/tutorial_page.tscn").instantiate()
var sports = load("res://Scenes/Sports/Sports.tscn").instantiate()
var minesweep = load("res://Scenes/Punch-In Level/OnlineMinesweeplvl.tscn").instantiate()

var current_page : Variant = null

func load_webpage(page):
	#print("aaa")
	self.add_child(page)
	current_page = page
	if current_page.has_signal("request_scene_change"):
		current_page.connect("request_scene_change", Callable(self, "_on_child_request_scene_change"))

func _on_child_request_scene_change(new_scene_path: String):
	current_page.queue_free()
	var page = load(new_scene_path).instantiate()
	load_webpage(page)
	
func _ready():
	load_webpage(tutorial)

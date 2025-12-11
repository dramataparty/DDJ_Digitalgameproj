extends Node2D

var tutorial = load("res://Scenes/tutorial_page.tscn").instantiate()
var sports = load("res://Scenes/SportsForum.tscn").instantiate()

func load_webpage(page):
	self.add_child(page)
	page.set("position", Vector2(400, 450))
	
func _ready():
	load_webpage(sports)

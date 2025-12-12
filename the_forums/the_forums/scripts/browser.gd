extends Node2D

var tutorial = load("res://Scenes/tutorial_page.tscn").instantiate()
var sports = load("res://Scenes/Sports/Sports.tscn").instantiate()

func load_webpage(page):
	self.add_child(page)
	
func _ready():
	load_webpage(sports)

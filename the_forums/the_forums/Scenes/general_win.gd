extends Node2D

signal request_scene_change(new_scene_path: String)

@export var progression_options: int
@export var next_scene: String

var is_level_complete = false

# Use onready to safely reference nodes
@onready var receptor = $Receptor
@onready var next_button = $nextButton

func _ready() -> void:
	# Connect signals from Receptor if you want dynamic updates
	receptor.connect("activated", Callable(self, "update_next_button_visibility"))
	receptor.connect("deactivated", Callable(self, "update_next_button_visibility"))
	
	update_next_button_visibility()

func update_next_button_visibility() -> void:
	next_button.visible = receptor.texture == receptor.spriteactive

func go_to_next_scene() -> void:
	emit_signal("request_scene_change", next_scene)

func _on_next_button_pressed() -> void:
	go_to_next_scene()

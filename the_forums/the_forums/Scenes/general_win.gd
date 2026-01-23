extends Node2D

signal request_scene_change(new_scene_path: String)

@export var progression_options: int
@export var next_scene: String

var is_level_complete = false
@onready var next_button = $nextButton

func _ready() -> void:
	# Hide the button initially
	next_button.visible = false

func on_level_complete() -> void:
	is_level_complete = true
	next_button.visible = true

func go_to_next_scene() -> void:
	emit_signal("request_scene_change", next_scene)

func _on_next_button_pressed() -> void:
	go_to_next_scene()

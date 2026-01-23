extends Node2D

signal request_scene_change(new_scene_path: String)

@export var progression_options: int
@export var next_scene: String

@onready var receptor = $Receptor
@onready var next_button = $nextButton

func go_to_next_scene() -> void:
	emit_signal("request_scene_change", next_scene)

func _on_next_button_pressed() -> void:
	go_to_next_scene()

func _on_poker_puzzle_puzzle_complete() -> void:
	next_button.visible = true
	pass 

extends Node2D


func _onready():
	if $PokerPuzzle.completed: 
		$nextButton.isvisible
		pass
func go_to_next_scene() -> void:
	emit_signal("request_scene_change", next_scene)

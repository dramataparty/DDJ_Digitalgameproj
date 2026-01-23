extends Sprite2D

@export var item_id: String = ""
@export var spriteinactive: Texture2D
@export var spriteactive: Texture2D
var key_strength: int = 0

signal activated(item_id: String)
signal deactivated(item_id: String)


func _on_area_2d_area_entered(area: Area2D) -> void:
	var item := area.get_parent()

	if item == null:
		return
	# Snap item to center
	item.global_position = global_position

	if not item is Sprite2D:
		return

	if item.item_id == item_id:
		item.texture = item.spriteactive

		if key_strength <= 0:
			activated.emit(item_id)
			texture = spriteactive

		key_strength += 1


func _on_area_2d_area_exited(area: Area2D) -> void:
	var item := area.get_parent()

	if item == null:
		return

	if not item is Sprite2D:
		return

	if item.item_id == item_id:
		item.texture = item.spriteinactive
		key_strength -= 1

		if key_strength <= 0:
			deactivated.emit(item_id)
			texture = spriteinactive

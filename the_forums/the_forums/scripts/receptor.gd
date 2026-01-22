extends Sprite2D

@export var item_id: String = ""
@export var spriteinactive: CompressedTexture2D
@export var spriteactive: CompressedTexture2D
var key_strength: int = 0
# accepts only items with this item_id

signal activated(item_id: String)
signal deactivated(item_id: String)

		
func _on_area_2d_area_entered(area: Area2D) -> void:
	var item = area.get_parent()
	if "item_id" in item:

		# Snap to the center of THIS Sprite2D
		item.global_position = global_position

		# Optional: stop any residual dragging movement
		if ("dragging" in item):
			item.dragging = false

	if "item_id" in item and item.item_id == item_id:
		# Update visuals
		item.texture = item.spriteactive
		if key_strength <= 0:
			activated.emit(item_id)
			texture = spriteactive
		key_strength += 1


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.get_parent().has_method("get_id") and area.get_parent().get_id() == item_id:
		area.get_parent().texture = area.get_parent().spriteinactive
		key_strength -= 1
		if key_strength <= 0:
			deactivated.emit(item_id)
			texture = spriteinactive

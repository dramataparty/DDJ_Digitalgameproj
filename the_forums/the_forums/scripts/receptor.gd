extends Sprite2D

@export var item_id: String = ""
@export var spriteinactive: CompressedTexture2D
@export var spriteactive: CompressedTexture2D
var key_strength: int = 0
# accepts only items with this item_id

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().has_method("get_id") and area.get_parent().get_id() == item_id:
		if key_strength <= 0:
			print("active")
			texture = spriteactive
		key_strength += 1

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.get_parent().has_method("get_id") and area.get_parent().get_id() == item_id:
		key_strength -= 1
		if key_strength <= 0:
			print("inactive")
			texture = spriteinactive

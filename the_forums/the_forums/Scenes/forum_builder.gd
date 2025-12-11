extends Node2D

@export var forum_post_scene: PackedScene
@export var forum_content_path: NodePath

var forum_messages = [
	{"user": "AlexBlueFC", "msg": "Lorem ipsum dolor sit amet, consectetur adipiscing elit,"},
	{"user": "RedPower", "msg": "Lorem ipsum dolor sit amet, consectetur adipiscing elit,"},
	{"user": "BlueLion", "msg": "Lorem ipsum dolor sit amet, consectetur adipiscing elit,"},
	{"user": "GreenGazer", "msg": "Lorem ipsum dolor sit amet, consectetur adipiscing elit,"},
	{"user": "UltraBlue", "msg": "Lorem ipsum dolor sit amet, consectetur adipiscing elit,"},
	{"user": "RedsUnited", "msg": "Lorem ipsum dolor sit amet, consectetur adipiscing elit,"},
	{"user": "GrassKick", "msg": "Lorem ipsum dolor sit amet, consectetur adipiscing elit,"},
	{"user": "BlueBomb", "msg": "Lorem ipsum dolor sit amet, consectetur adipiscing elit,"},
	{"user": "StatsGuy", "msg": "Lorem ipsum dolor sit amet, consectetur adipiscing elit,"},
]

func _ready():
	_populate_forum()

func _populate_forum():
	var content = get_node(forum_content_path)

	for msg in forum_messages:
		var post = forum_post_scene.instantiate()
		post.username = msg["user"]
		post.message_text = msg["msg"]
		content.add_child(post)

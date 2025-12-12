extends RichTextLabel

func _ready():
	bbcode_enabled = true
	text = """[color=#000000]
[font_size=36][b]Tutorial[/b][/font_size]
Hello and welcome to THE FORUMS!
Under the browser you should have a panel that brings up your abilities!
[/color]
"""

func _on_receptor_activated(item_id: String) -> void:
	text = """[color=#000000]
[font_size=36][b]Congratulations![/b][/font_size]
You have now become death, destroyer of worlds!
[/color]
"""


func _on_receptor_deactivated(item_id: String) -> void:
	text = """[color=#000000]
[font_size=36][b]Tutorial[/b][/font_size]
Hello and welcome to THE FORUMS!
Under the browser you should have a panel that brings up your abilities!(bababooie)
[/color]
"""

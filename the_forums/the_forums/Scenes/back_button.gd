extends Button

func _ready():
	pressed.connect(_on_pressed)

func _on_pressed():
	back()
	
func back():
		$"../WebPage".back()

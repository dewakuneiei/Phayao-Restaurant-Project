extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	
	pressed.connect(_on_pressed)

func _on_pressed():
	$"../../..".hide()
	GameManager.play_sfx()


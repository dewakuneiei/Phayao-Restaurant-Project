extends PanelContainer
class_name GamePauseUI

@export var setting_paenl: PanelContainer

func enable():
	GameManager.pause_game()
	show()

func disable():
	GameManager.resume_game()
	hide()

func _show_setting_ui():
	setting_paenl.show()

func _ready():
	setting_paenl.hide()
	%Resume.connect("pressed", disable)
	%Home.connect("pressed", GameManager.load_main_scene)
	%Again.connect("pressed", GameManager.load_game_scene)
	hide()
	

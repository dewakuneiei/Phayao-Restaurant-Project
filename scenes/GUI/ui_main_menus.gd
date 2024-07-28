extends Control

@onready var gameplay_scene = preload("res://scenes/university_point.tscn")
@onready var tutorial_panel = $Tutorial
@export var setting_panel: PanelContainer

func _ready():
	set_process(false)
	set_process_input(false)
	
	%Settings.connect("pressed", _on_settings_pressed)
	%PlayBtn.connect("pressed", _on_play_clicked)
	%TutorialBtn.connect("pressed", _tutorial_pressed)
	%TutorialClose.connect("pressed", _on_close_tutorial)
	setting_panel.hide()
	

func _update_text():
	%MoneyGoal.text = "%s: %d"%[tr("MONEY_GOAL"), GameManager.GOAL_PROFIT]
	%FoodRecipes.text = "%s: Q" % tr("FOOD_RECIPES")
	%Interaction.text = "%s: E" % tr("INTERACTION")
	%Movement.text = "%s: WASD" % tr("MOVEMENT")
	%LeftMouse.text = "%s: %s" % [tr("HIT_CUSTOMER"), tr("LEFT_MOUSE")]

func _tutorial_pressed():
	_update_text()
	tutorial_panel.show()
	GameManager.play_sfx()

func _on_close_tutorial():
	tutorial_panel.hide()
	GameManager.play_sfx()

func _on_settings_pressed():
	setting_panel.show()
	GameManager.play_sfx()

func _on_play_clicked():
	GameManager.play_sfx()
	GameManager.load_game_scene()
	

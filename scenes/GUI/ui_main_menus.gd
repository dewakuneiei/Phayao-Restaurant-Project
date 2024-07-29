extends Control

@onready var gameplay_scene = preload("res://scenes/university_point.tscn")
@onready var tutorial_panel = $Tutorial
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var setting_panel: PanelContainer
@export var game_credits: PanelContainer

func _ready():
	set_process(false)
	set_process_input(false)
	
	%Settings.connect("pressed", _on_settings_pressed)
	%PlayBtn.connect("pressed", _on_play_clicked)
	%TutorialBtn.connect("pressed", _tutorial_pressed)
	%TutorialClose.connect("pressed", _on_close_tutorial)
	%Credit.connect("pressed", _on_credits_pressed)
	setting_panel.hide()
	

func _on_credits_pressed():
	game_credits.show()
	animation_player.play("open_credits")

func _update_text():
	%FoodRecipes.text = "%s: Q" % tr("FOOD_RECIPES")
	%Interaction.text = "%s: E" % tr("INTERACTION")
	%Movement.text = "%s: WASD" % tr("MOVEMENT")
	%LeftMouse.text = "%s: %s" % [tr("HIT_CUSTOMER"), tr("LEFT_MOUSE")]
	%LeftMouse2.text = "%s: %s" % [tr("GET_MONEY"), tr("LEFT_MOUSE")]

func _tutorial_pressed():
	_update_text()
	tutorial_panel.show()
	animation_player.play("open_tutorial")
	GameManager.play_sfx()

func _on_close_tutorial():
	tutorial_panel.hide()
	GameManager.play_sfx()

func _on_settings_pressed():
	setting_panel.show()
	animation_player.play("open_settings")
	GameManager.play_sfx()

func _on_play_clicked():
	GameManager.play_sfx()
	GameManager.load_game_scene()
	

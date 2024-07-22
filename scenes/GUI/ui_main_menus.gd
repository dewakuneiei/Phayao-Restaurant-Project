extends Control

@onready var gameplay_scene = preload("res://scenes/university_point.tscn")

func _ready():
	set_process(false)
	set_process_input(false)
	
	%Settings.connect("pressed", _on_settings_pressed)
	%PlayBtn.connect("pressed", _on_play_clicked)
	%SettingClose.connect("pressed", _on_close_pressed)
	%SettingPanelContainer.hide()



func _on_close_pressed():
	%SettingPanelContainer.hide()
	%Menus.show()
	GameManager.play_sfx()

func _on_settings_pressed():
	%Menus.hide()
	%SettingPanelContainer.show()
	GameManager.play_sfx()

func _on_play_clicked():
	GameManager.play_sfx()
	GameManager.load_game_scene()

func _on_toggle_lang_bnt_pressed():
	GameManager.play_sfx()
	LanguageManager.toggle_language()
	

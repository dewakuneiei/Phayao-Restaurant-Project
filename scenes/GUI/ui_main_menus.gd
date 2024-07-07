extends Control

var gameplay_scene = preload("res://scenes/university_point.tscn")

func _ready():
	set_process(false)
	set_process_input(false)
	
	%PlayBtn.connect("pressed", _on_play_clicked)


func _on_play_clicked():
	GameManager.load_game_scene()

func _on_toggle_lang_bnt_pressed():
	LanguageManager.toggle_language()
	

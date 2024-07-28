extends Button

func _ready():
	set_process(false)
	pressed.connect(_on_toggle_lang_bnt_pressed)

func _on_toggle_lang_bnt_pressed():
	GameManager.play_sfx()
	LanguageManager.toggle_language()

extends PanelContainer

func _ready():
	%credit_text.meta_clicked.connect(_on_RichTextLabel_meta_clicked)
	%CloseBtn.connect("pressed", _on_close_pressed)

func _on_close_pressed():
	GameManager.play_sfx()
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED

func _on_RichTextLabel_meta_clicked(meta):
	OS.shell_open(str(meta))

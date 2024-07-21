extends Control
class_name GamePlayUI

@onready var money_l : Label = %Money
@onready var time_l : Label = %Time
@onready var open_btn : Button = %Open
var time_left: float

func _process(delta):
	time_left -= delta
	_update_time_label()
	if time_left <= 0:
		set_process(false)
		GameManager.set_game_state(GameManager.GameState.ENDED)
		print(name, " set game ended state.")

func _ready():
	_initialized()
	set_process(false)
	set_process_input(false)
	set_physics_process(false)

func _initialized():
	time_l.hide()
	time_left = GameManager.GAME_DURATION
	money_l.text = str(GameManager.money) + " " + tr("BAHT")
	GameManager.updated_money.connect(_on_money_updated)

func _time_start():
	time_l.show()
	set_process(true)

func _on_money_updated(new_value: int):
	money_l.text = str(new_value) + " " + tr("BAHT")

func _on_button_pressed():
	open_btn.hide()
	_time_start()
	GameManager.play_sfx_with_stream(load("res://assets/sfx/shop-door-bell.mp3"))

func _update_time_label():
	var total_seconds = roundi(time_left)
	var minutes = total_seconds / 60
	var seconds = total_seconds % 60
	
	# Determine whether to show only seconds or both minutes and seconds
	if total_seconds < 60:
		# Show only seconds when time_left is less than 60 seconds
		var padded_seconds = str(seconds)
		if seconds < 10:
			padded_seconds = "0" + str(seconds)
		time_l.text = padded_seconds
	else:
		# Show both minutes and seconds otherwise
		var padded_minutes = str(minutes)
		var padded_seconds = str(seconds)
		if seconds < 10:
			padded_seconds = "0" + str(seconds)
		time_l.text = padded_minutes + ":" + padded_seconds


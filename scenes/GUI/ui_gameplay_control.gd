extends Control

@export var gameSytem: GameSystem
@export_range(120, 10*60) var gameTime: int = 5 * 60
@onready var money_l : Label = %MoneyLabel
@onready var time_left_l : Label = $Label
var time_left: float

func _ready():
	_initialized()
	set_process(false)
	set_process_input(false)
	set_physics_process(false)

func _process(delta):
	_countdown_timeout(delta)

func _initialized():
	if gameSytem == null:
		gameSytem = GameSystem.instance
	
	money_l.text = str(gameSytem.get_money()) + " B"
	time_left_l.hide()
	gameSytem.money_updated.connect(_on_money_updated)
	
	time_left = gameTime
	_update_time_display()

func _countdown_timeout(down_value: float):
	time_left -= down_value
	_update_time_display()
	if time_left <= 0:
		_on_game_time_up()
		set_process(false)

func _update_time_display():
	var minutes: int = int(time_left) / 60
	var seconds: int = int(time_left) % 60
	
	if minutes > 0:
		time_left_l.text = "%d:%02d" % [minutes, seconds]
	else:
		time_left_l.text = str(seconds)


func _on_money_updated(new_value: int):
	money_l.text = str(new_value) + " B"

func _on_game_time_up():
	GameManager.set_game_state(GameManager.GameState.ENDED)

func _on_button_pressed():
	$Button.hide()
	time_left_l.show()
	set_process(true)

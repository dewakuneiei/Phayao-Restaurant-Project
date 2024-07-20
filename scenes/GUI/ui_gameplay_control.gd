extends Control
class_name GamePlayUI

@onready var money_l : Label = %MoneyLabel
@onready var open_btn : Button = %Open
var time_left: float

func _ready():
	_initialized()
	set_process(false)
	set_process_input(false)
	set_physics_process(false)

func _initialized():
	
	money_l.text = str(GameManager.money) + " BAHT"
	GameManager.updated_money.connect(_on_money_updated)
	

func _on_money_updated(new_value: int):
	money_l.text = str(new_value) + " B"

func _on_button_pressed():
	open_btn.hide()

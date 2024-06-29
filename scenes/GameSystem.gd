extends Node
class_name GameSystem

static var instance: GameSystem

@export var player: Player
@export var fridge: Fridge
@export var shop: Array[Shop]

var _money: int

func _ready():
	instance = self
	earn_money(1000)

func spend_money(amount: float):
	_money -= amount
	print(_money)
	if _money < 0:
		_money = 0

func earn_money(amount: float):
	_money += amount

func get_money():
	return _money

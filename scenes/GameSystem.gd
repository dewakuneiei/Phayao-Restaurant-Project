extends Node
class_name GameSystem

static var instance: GameSystem
static var load_icons: Dictionary = {
	"Fish": load("res://assets/sprites/ingredients/fish.png"), 
	"Pork": load("res://assets/sprites/ingredients/pork.png"), 
	"Salt": load("res://assets/sprites/ingredients/salt.png"),
	"Chili": load("res://assets/sprites/ingredients/chili.png"), 
	"Chicken": load("res://assets/sprites/ingredients/chicken.png"), 
	"Noodles": load("res://assets/sprites/ingredients/noodles.png"), 
	"Lime": load("res://assets/sprites/ingredients/lime.png"), 
	"Egg": load("res://assets/sprites/ingredients/egg.png"), 
	"Crab": load("res://assets/sprites/ingredients/crab.png") 
}

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

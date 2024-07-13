extends Node
class_name GameSystem

static var instance: GameSystem

@export_category("refference")
@export var player: Player
@export var fridge: Fridge
@export var shop: Shop
@export var ui_ended_game: GameEndUi
@export var counter: Counter
@export var endPoint: Marker2D
@export var spawner: Spawner

signal money_updated(new_value: int)

var _money: int
var timer: Timer

func _ready():
	instance = self
	earn_money(300) # start with 
	GameManager.set_game_state(GameManager.GameState.NONE)
	GameManager.game_state_changed.connect(_on_game_state_changed)

func started_game():
	GameManager.set_game_state(GameManager.GameState.STARTED)
	spawner.start_spawner()

func ended_game():
	ui_ended_game.process_mode = Node.PROCESS_MODE_ALWAYS
	ui_ended_game.update_ui()
	ui_ended_game.show()
	get_tree().paused = true

func spend_money(amount: float):
	_money -= amount
	if _money < 0:
		_money = 0
	money_updated.emit(_money)
	GameManager.cost += amount

func earn_money(amount: float):
	_money += amount
	money_updated.emit(_money)
	GameManager.revenue += amount

func get_money():
	return _money

func get_all_food_menus() -> Array:
	return GameManager.all_food_menus.values()

func get_random_food_menu() -> FoodData:
	var all_menus = get_all_food_menus()
	var random_index = randi() % all_menus.size()
	return all_menus[random_index]

func _on_button_pressed():
	started_game()

func _on_game_state_changed(new_state):
	match new_state:
		GameManager.GameState.NONE:
			print("Game is in NONE state")
		GameManager.GameState.STARTED:
			print("Game has STARTED")
		GameManager.GameState.ENDED:
			ended_game()

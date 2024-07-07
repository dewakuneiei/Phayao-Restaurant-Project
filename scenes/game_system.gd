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
	"Crab": load("res://assets/sprites/ingredients/crab.png"),
	"Coriander": load("res://assets/sprites/ingredients/coriander.png") 
}

@export_category("refference")
@export var player: Player
@export var fridge: Fridge
@export var shop1: Shop
@export var shop2: Shop
@export var recipes: FoodRecipes
@export var ui_ended_game: GameEndUi
@export var counter: Counter
@export var endPoint: Marker2D
@export var spawner: Spawner

@onready var unknown_menu: FoodData = FoodData.new("Unknown", 40, load("res://assets/sprites/foods/food.png"))
@onready var chicken_khao_soi: FoodData = FoodData.new("Chicken_Khao_Soi", 50, load("res://assets/sprites/foods/food.png"))
@onready var khai_pam: FoodData = FoodData.new("Khai_Pam", 45, load("res://assets/sprites/foods/food.png"))
@onready var ong_pu_na: FoodData = FoodData.new("Ong_Pu_Na", 70, load("res://assets/sprites/foods/food.png"))
@onready var aeb_pla_nil: FoodData = FoodData.new("Aeb_Pla_Nil", 55, load("res://assets/sprites/foods/food.png"))
@onready var lon_pla_som: FoodData = FoodData.new("Lon_Pla_Som", 50, load("res://assets/sprites/foods/food.png"))
@onready var burnt_food: FoodData = FoodData.new("burnt_food", 1, load("res://assets/sprites/foods/food.png"))

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

func get_all_food_menus() -> Array[FoodData]:
	return [chicken_khao_soi, khai_pam, ong_pu_na, aeb_pla_nil, lon_pla_som]

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

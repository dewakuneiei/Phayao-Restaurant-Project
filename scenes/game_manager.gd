extends Node

signal game_state_changed(new_state)
signal updated_money(newValue)

enum GameState {
	NONE,
	STARTED,
	ENDED
}


const START_RATING_AT = 3
const GOAL_MONEY: int = 320
const BASE_AMOUNT: int = 1 #Base number of customers
const MAX_RATING: int = 10 # Maximum possible rating
const MAX_AMOUNT: int = 3  # Maximum number of customers for a perfect rating

@onready var gameplay_scene: PackedScene = preload("res://scenes/university_point.tscn")
@onready var main_game_scene: PackedScene = preload("res://scenes/GUI/ui_main_menus.tscn")

@onready var all_food_menus = {
	"UNKNOWN_FOOD": FoodData.new("unknown", 1, preload("res://assets/sprites/foods/unknown_food.png")),
	"BURNT_FOOD": FoodData.new("burnt_food", 1, preload("res://assets/sprites/foods/burnt_food.png")),
	"CHICKEN_KHAO_SOI": FoodData.new("Chicken_Khao_Soi", 100, preload("res://assets/sprites/foods/chicken_khao_soi.png")),
	"KHAI_PAM": FoodData.new("Khai_Pam", 100, preload("res://assets/sprites/foods/khai_pam.png")),
	"ONG_PU_NA": FoodData.new("Ong_Pu_Na", 100, preload("res://assets/sprites/foods/ong_pu_na.png")),
	"AEB_PLA_NIL": FoodData.new("Aeb_Pla_Nil", 100, preload("res://assets/sprites/foods/aeb_pla_nil.png")),
	"LON_PLA_SOM": FoodData.new("Lon_Pla_Som", 100, preload("res://assets/sprites/foods/lon_pla_som.png")),
}

@onready var all_ingredients = [
	IngredientData.new(0, "Fish", 10, preload("res://assets/sprites/ingredients/fish.png")),
	IngredientData.new(1, "Pork", 10, preload("res://assets/sprites/ingredients/pork.png")),
	IngredientData.new(2, "Chicken", 10, preload("res://assets/sprites/ingredients/chicken.png")),
	IngredientData.new(3, "CHICKEN_EGG", 10, preload("res://assets/sprites/ingredients/chicken_egg.png")),
	IngredientData.new(4, "FIELD_CRAB", 10, preload("res://assets/sprites/ingredients/crab.png")),
	IngredientData.new(5, "Salt", 2, preload("res://assets/sprites/ingredients/salt.png")),
	IngredientData.new(6, "Chili", 2, preload("res://assets/sprites/ingredients/chili.png")),
	IngredientData.new(7, "RICE_NOODLE", 2, preload("res://assets/sprites/ingredients/noodle.png")),
	IngredientData.new(8, "Lime", 2, preload("res://assets/sprites/ingredients/lime.png")),
	IngredientData.new(9, "Cilantro", 2, preload("res://assets/sprites/ingredients/coriander.png"))
]

var _game_state: GameState = GameState.NONE
var rating: int
var money: int

var gameSystem: GameSystem
var sale_food_log: Dictionary

func get_game_state() -> GameState:
	return _game_state

func set_game_state(new_state: GameState) -> void:
	if _game_state != new_state:
		_game_state = new_state
		game_state_changed.emit(_game_state)

func decrease_rating():
	rating -= 1
	rating = clamp(rating, 1, MAX_RATING)
	print("Rating: ", rating)

func increase_rating():
	rating += 1
	rating = clamp(rating, 1, MAX_RATING)
	print("Rating: ", rating)

func calculate_customer_amount() -> int:
	# Ensure rating is within valid range
	rating = clamp(rating, 1, MAX_RATING)
	# Calculate amount based on rating
	var amount: int = BASE_AMOUNT + (rating * (MAX_AMOUNT - BASE_AMOUNT) / MAX_RATING)
	print("amount: ", amount, " Rating: ", rating)
	return amount

func update_money(amount: int):
	money += amount
	updated_money.emit(money)
	if money >= GOAL_MONEY:
		set_game_state(GameState.ENDED)

func reset():
	_game_state = GameState.NONE
	money = 300
	rating = START_RATING_AT
	gameSystem = null
	sale_food_log.clear()

func load_game_scene():
	get_tree().paused = false
	reset()
	get_tree().change_scene_to_packed(gameplay_scene)

func load_main_scene():
	get_tree().change_scene_to_packed(main_game_scene)
	get_tree().paused = false

func pause_game():
	get_tree().paused = true

func resume_game():
	get_tree().paused = false

func update_log(data: FoodData):
	if sale_food_log.has(data):
		sale_food_log[data] += 1
	else:
		sale_food_log[data] = 1
	
	print("LOG: ", sale_food_log)

func get_game_log() -> Dictionary:
	return sale_food_log

func started():
	_game_state = GameState.STARTED

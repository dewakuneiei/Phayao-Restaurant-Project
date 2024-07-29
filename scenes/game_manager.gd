extends Node

signal game_state_changed(new_state)
signal updated_money(new_value)

enum GameState { NONE, STARTED, ENDED }

const MIN_RATING = 3
const GOAL_PROFIT = 300
const BASE_MONEY = 150
const BASE_CUSTOMER_AMOUNT = 1
const MAX_RATING = 10
const MAX_CUSTOMER_AMOUNT = 5
const GAME_DURATION = 365# in seconds time

var _game_state: GameState = GameState.NONE
var rating: int
var money: int
var total_revenue: int = 0
var total_expenses: int = 0

var gameSystem: GameSystem
var game_log: Dictionary

@onready var gameplay_scene: PackedScene = preload("res://scenes/university_point.tscn")
@onready var main_game_scene: PackedScene = preload("res://scenes/GUI/ui_main_menus.tscn")
@onready var all_food_menus: Dictionary = _initialize_food_menus()
@onready var all_ingredients: Array[IngredientData] = _initialize_ingredients()
@onready var stream_sfx_03: AudioStream = preload("res://assets/sfx/ui/MI_SFX 03.mp3")
@onready var stream_sfx_21: AudioStream = preload("res://assets/sfx/ui/MI_SFX 21.mp3")

func play_sfx_with_stream(stream: AudioStream):
	var streamPlayer = AudioStreamPlayer.new()
	streamPlayer.bus = "SFX"
	streamPlayer.stream = stream
	streamPlayer.finished.connect(_remove_node.bind(streamPlayer))
	add_child(streamPlayer)
	streamPlayer.play()

func play_sfx():
	var streamPlayer = AudioStreamPlayer.new()
	streamPlayer.bus = "SFX"
	streamPlayer.stream = stream_sfx_03
	streamPlayer.finished.connect(_remove_node.bind(streamPlayer))
	add_child(streamPlayer)
	streamPlayer.play()

func get_game_state() -> GameState:
	return _game_state

func set_game_state(new_state: GameState) -> void:
	if _game_state != new_state:
		_game_state = new_state
		game_state_changed.emit(_game_state)

func adjust_rating(amount: int) -> void:
	rating = clamp(rating + amount, 1, MAX_RATING)
	print("Rating: ", rating)

func calculate_customer_amount() -> int:
	return BASE_CUSTOMER_AMOUNT + (rating * (MAX_CUSTOMER_AMOUNT - BASE_CUSTOMER_AMOUNT) / MAX_RATING)

func update_money(amount: int) -> void:
	money += amount
	if amount > 0:
		total_revenue += amount
	else:
		total_expenses += -amount  # Convert negative expense to positive for tracking
	updated_money.emit(money)

# Function to calculate and return net profit
func get_net_profit() -> int:
	return total_revenue - total_expenses

func reset() -> void:
	_game_state = GameState.NONE
	money = BASE_MONEY
	total_revenue = 0
	total_expenses = 0
	rating = MIN_RATING
	gameSystem = null
	game_log = {}

func load_game_scene() -> void:
	reset()
	get_tree().paused = false
	get_tree().change_scene_to_packed(gameplay_scene)

func load_main_scene() -> void:
	get_tree().change_scene_to_packed(main_game_scene)
	get_tree().paused = false

func decrease_rating():
	rating = clamp(rating - 1, MIN_RATING, MAX_RATING)

func decrease_rating2():
	rating = clamp(rating - 2, MIN_RATING, MAX_RATING)

func increase_rating():
	rating = clamp(rating + 1, MIN_RATING, MAX_RATING)

func increase_rating2():
	rating = clamp(rating + 2, MIN_RATING, MAX_RATING)

func pause_game() -> void:
	get_tree().paused = true

func resume_game() -> void:
	get_tree().paused = false

func started() -> void:
	_game_state = GameState.STARTED

func update_log(data: FoodData) -> void:
	if game_log.has(data):
		game_log[data] += 1
	else:
		game_log[data] = 1

func is_game_started() -> bool:
	return _game_state == GameState.STARTED

func _initialize_food_menus() -> Dictionary:
	return {
		"UNKNOWN_FOOD": FoodData.new(11, "unknown", 5, preload("res://assets/sprites/dish/sprite11.png")),
		"BURNT_FOOD": FoodData.new(12, "burnt_food", 1, preload("res://assets/sprites/dish/sprite12.png")),
		"CHICKEN_KHAO_SOI": FoodData.new(13, "Chicken_Khao_Soi", 70, preload("res://assets/sprites/dish/sprite13.png")),
		"LON_PLA_SOM": FoodData.new(14, "Lon_Pla_Som", 75, preload("res://assets/sprites/dish/sprite14.png")),
		"KHAI_PAM": FoodData.new(15, "Khai_Pam", 75, preload("res://assets/sprites/dish/sprite15.png")),
		"ONG_PU_NA": FoodData.new(16, "Ong_Pu_Na", 75, preload("res://assets/sprites/dish/sprite16.png")),
		"AEB_PLA_NIL": FoodData.new(17, "AEB_PLA_NIL", 75, preload("res://assets/sprites/dish/sprite17.png")),
	}


func _initialize_ingredients() -> Array[IngredientData]:
	return [
		IngredientData.new(0, "Fish", 5, preload("res://assets/sprites/dish/sprite00.png")),
		IngredientData.new(1, "Pork", 5, preload("res://assets/sprites/dish/sprite01.png")),
		IngredientData.new(2, "Chicken", 5, preload("res://assets/sprites/dish/sprite02.png")),
		IngredientData.new(3, "CHICKEN_EGG", 5, preload("res://assets/sprites/dish/sprite03.png")),
		IngredientData.new(4, "FIELD_CRAB", 5, preload("res://assets/sprites/dish/sprite04.png")),
		IngredientData.new(5, "Salt", 5, preload("res://assets/sprites/dish/sprite05.png")),
		IngredientData.new(6, "Chili", 5, preload("res://assets/sprites/dish/sprite06.png")),
		IngredientData.new(7, "RICE_NOODLE", 5, preload("res://assets/sprites/dish/sprite07.png")),
		IngredientData.new(8, "Lime", 5, preload("res://assets/sprites/dish/sprite08.png")),
		IngredientData.new(9, "CILANTRO", 5, preload("res://assets/sprites/dish/sprite09.png"))
	]


func _remove_node(node: Node):
	node.queue_free()

func _ready() -> void:
	reset()

extends Node

signal game_state_changed(new_state)
signal updated_money(new_value)

enum GameState { NONE, STARTED, ENDED }

const START_RATING = 3
const GOAL_MONEY = 500
const BASE_CUSTOMER_AMOUNT = 1
const MAX_RATING = 100
const MAX_CUSTOMER_AMOUNT = 5
const GAME_DURATION = 120 # in seconds time

var _game_state: GameState = GameState.NONE
var rating: int = START_RATING
var money: int = 300

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
	updated_money.emit(money)

func reset() -> void:
	_game_state = GameState.NONE
	money = 300
	rating = START_RATING
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
	rating = clamp(rating - 1, 1, MAX_RATING)

func decrease_rating2():
	rating = clamp(rating - 2, 1, MAX_RATING)

func increase_rating():
	rating = clamp(rating + 1, 1, MAX_RATING)

func increase_rating2():
	rating = clamp(rating + 2, 1, MAX_RATING)

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
		"UNKNOWN_FOOD": FoodData.new("unknown", 100, preload("res://assets/sprites/foods/unknown_food.png")),
		"BURNT_FOOD": FoodData.new("burnt_food", 1, preload("res://assets/sprites/foods/burnt_food.png")),
		"CHICKEN_KHAO_SOI": FoodData.new("Chicken_Khao_Soi", 100, preload("res://assets/sprites/foods/chicken_khao_soi.png")),
		"KHAI_PAM": FoodData.new("Khai_Pam", 100, preload("res://assets/sprites/foods/khai_pam.png")),
		"ONG_PU_NA": FoodData.new("Ong_Pu_Na", 100, preload("res://assets/sprites/foods/ong_pu_na.png")),
		"AEB_PLA_NIL": FoodData.new("Aeb_Pla_Nil", 100, preload("res://assets/sprites/foods/aeb_pla_nil.png")),
		"LON_PLA_SOM": FoodData.new("Lon_Pla_Som", 100, preload("res://assets/sprites/foods/lon_pla_som.png")),
	}

func _initialize_ingredients() -> Array[IngredientData]:
	return [
		IngredientData.new(0, "Fish", 2, preload("res://assets/sprites/ingredients/fish.png")),
		IngredientData.new(1, "Pork", 2, preload("res://assets/sprites/ingredients/pork.png")),
		IngredientData.new(2, "Chicken", 2, preload("res://assets/sprites/ingredients/chicken.png")),
		IngredientData.new(3, "CHICKEN_EGG", 2, preload("res://assets/sprites/ingredients/chicken_egg.png")),
		IngredientData.new(4, "FIELD_CRAB", 2, preload("res://assets/sprites/ingredients/crab.png")),
		IngredientData.new(5, "Salt", 2, preload("res://assets/sprites/ingredients/salt.png")),
		IngredientData.new(6, "Chili", 2, preload("res://assets/sprites/ingredients/chili.png")),
		IngredientData.new(7, "RICE_NOODLE", 2, preload("res://assets/sprites/ingredients/noodle.png")),
		IngredientData.new(8, "Lime", 2, preload("res://assets/sprites/ingredients/lime.png")),
		IngredientData.new(9, "Cilantro", 2, preload("res://assets/sprites/ingredients/coriander.png"))
	]

func _remove_node(node: Node):
	node.queue_free()

func _ready() -> void:
	reset()

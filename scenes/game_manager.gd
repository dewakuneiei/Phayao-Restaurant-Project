extends Node

signal game_state_changed(new_state)

enum GameState {
	NONE,
	STARTED,
	ENDED
}

const START_RATING_AT = 3
const GOAL_PROFIT = 500
const BASE_AMOUNT: int = 1 #Base number of customers
const MAX_RATING: int = 10 # Maximum possible rating
const MAX_AMOUNT: int = 3  # Maximum number of customers for a perfect rating

@onready var gameplay_scene: PackedScene = preload("res://scenes/university_point.tscn")
@onready var main_game_scene: PackedScene = preload("res://scenes/GUI/ui_main_menus.tscn")

var _game_state: GameState = GameState.NONE
var rating: int
var revenue: int
var cost: int


func get_game_state() -> GameState:
	return _game_state

func set_game_state(new_state: GameState) -> void:
	if _game_state != new_state:
		_game_state = new_state
		emit_signal("game_state_changed", _game_state)

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

func get_profit():
	return revenue - cost

func calculate_score():
	var profit = get_profit()
	if profit < GOAL_PROFIT:
		return 0
	elif profit < GOAL_PROFIT * 1.5:
		return 1
	elif profit < floori(GOAL_PROFIT * 1.7):
		return 2
	else:
		return 3

func reset():
	revenue = 0
	cost = 0
	rating = START_RATING_AT

func load_game_scene():
	get_tree().change_scene_to_packed(gameplay_scene)
	get_tree().paused = false
	reset()

func load_main_scene():
	get_tree().change_scene_to_packed(main_game_scene)
	get_tree().paused = false

func pause_game():
	get_tree().paused = true

func resume_game():
	get_tree().paused = false

extends Node
class_name GameSystem

static var instance: GameSystem

@export_category("refference")
@export var player: Player
@export var fridge: Fridge
@export var shop: Shop
@export var counter: Counter
@export var endPoint: Marker2D
@export var spawner: Spawner
@export_category("Game UI")
@export var ui_gameplay: GamePlayUI
@export var ui_ended_game: GameEndUi
@export var ui_recipe: RecipeUI
@export var ui_gamepause: GamePauseUI

func get_all_food_menus() -> Array:
	return GameManager.all_food_menus.values().filter(func(food): 
		return food.get_name() != "UNKNOWN" and food.get_name() != "BURNT_FOOD"
	)

func get_random_food_menu() -> FoodData:
	var all_menus = get_all_food_menus()
	var random_index = randi() % all_menus.size()
	return all_menus[random_index]

func toggle_recipe():
	if ui_recipe.visible:
		ui_recipe.hide()
	else:
		ui_recipe.show()

func _ready():
	instance = self
	GameManager.gameSystem = self
	GameManager.game_state_changed.connect(_on_game_state_changed)

func _on_game_state_changed(newState: GameManager.GameState):
	match (newState):
		GameManager.GameState.ENDED:
			fridge.ui_storage.hide()
			ui_recipe.hide()
			shop.shop_ui.hide()
			ui_ended_game.show_me()
			ui_gamepause.hide()

func _on_open_pressed():
	GameManager.started()
	spawner.start_spawner()


func _on_texture_button_pressed():
	toggle_recipe()

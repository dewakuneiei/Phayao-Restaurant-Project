extends CookingTable
class_name BoilTable

var food_texture: Texture = preload("res://assets/sprites/foods/food.png")

func _match_food_data(keys: Array) -> FoodData:
	if gameSystem == null: gameSystem = GameSystem.instance
	keys.sort()
	match keys:
		#chicken_khao_soi
		[0, 3, 8, 9]:
			return gameSystem.chicken_khao_soi
		_:
			return gameSystem.unknown_menu

extends CookingTable
class_name FriedTable

var food_texture: Texture = preload("res://assets/sprites/foods/food.png")

func _match_food_data(keys: Array) -> FoodData:
	if gameSystem == null: gameSystem = GameSystem.instance
	
	keys.sort()

	match keys:
		#Lon Pla Som Phayao
		[1, 2, 6, 7]:
			return gameSystem.lon_pla_som
		_:
			return gameSystem.unknown_menu

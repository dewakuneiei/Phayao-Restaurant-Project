extends CookingTable
class_name GrillTable

var food_texture: Texture = preload("res://assets/sprites/foods/food.png")

func _match_food_data(keys: Array) -> FoodData:
	if gameSystem == null: gameSystem = GameSystem.instance
	
	keys.sort()
	match keys:
		#Khai Pam
		[4, 4, 6, 7]:
			return gameSystem.khai_pam
		#Ong Pu Na
		[4, 5, 5, 6]:
			return gameSystem.ong_pu_na
		#Aeb Pla Nil
		[0, 1, 6, 7]:
			return gameSystem.aeb_pla_nil
		_:
			return gameSystem.unknown_menu

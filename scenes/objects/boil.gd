extends CookingTable
class_name BoilTable

func _match_food_data(keys: Array) -> FoodData:
	keys.sort()
	match keys:
		#chicken_khao_soi
		[2, 7, 8, 9]:
			return GameManager.all_food_menus["CHICKEN_KHAO_SOI"]
		_:
			return GameManager.all_food_menus["UNKNOWN_FOOD"]

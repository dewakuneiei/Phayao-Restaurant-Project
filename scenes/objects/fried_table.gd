extends CookingTable
class_name FriedTable

func _match_food_data(keys: Array) -> FoodData:
	keys.sort()

	match keys:
		#Lon Pla Som Phayao
		[0, 1, 5, 6]:
			return GameManager.all_food_menus["LON_PLA_SOM"]
		_:
			return GameManager.all_food_menus["UNKNOWN_FOOD"]

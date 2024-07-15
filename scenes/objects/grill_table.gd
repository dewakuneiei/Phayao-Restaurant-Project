extends CookingTable
class_name GrillTable

func _match_food_data(keys: Array) -> FoodData:
	keys.sort()
	
	for food_name in Recipe.food_recipes.keys():
		if keys == Recipe.get_ingredient_ids_for_food(food_name):
			return GameManager.all_food_menus[food_name]
	
	return GameManager.all_food_menus["UNKNOWN_FOOD"]


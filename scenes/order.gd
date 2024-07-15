class_name Recipe

var food: FoodData
var ingredients: Array[IngredientData]

# Dictionary to store food recipes
static var food_recipes = {
	"CHICKEN_KHAO_SOI": [2, 7, 8, 9],
	"KHAI_PAM": [3, 3, 5, 6],
	"ONG_PU_NA": [3, 4, 4, 5],
	"AEB_PLA_NIL": [0, 5, 6, 9],
	"LON_PLA_SOM": [0, 1, 5, 6]
}

func _init(food_data: FoodData, ingredient_array: Array[IngredientData]):
	self.food = food_data
	self.ingredients = ingredient_array

static func create_order(ingredients: Array[IngredientData]) -> Recipe:
	var ids = get_all_ingredient_ids(ingredients)
	ids.sort()
	var food_data = match_food_data(ids)
	return Recipe.new(food_data, ingredients)

static func get_all_ingredient_ids(ingredients: Array[IngredientData]) -> Array[int]:
	return ingredients.map(func(item): return item.get_id())

static func match_food_data(ids: Array[int]) -> FoodData:
	for food_name in food_recipes:
		if ids == food_recipes[food_name]:
			return GameManager.all_food_menus[food_name]
	return GameManager.all_food_menus["UNKNOWN_FOOD"]

static func get_ingredient_ids_for_food(name: StringName) -> Array[int]:
	var upper_name = name.to_upper()
	var result: Array[int] = []
	if upper_name in food_recipes:
		result.append_array(food_recipes[upper_name])
	return result

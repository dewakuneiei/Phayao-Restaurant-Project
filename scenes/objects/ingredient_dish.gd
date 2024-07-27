extends Dish
class_name IngredientDish

var ingredientData: IngredientData

func get_icon() -> Texture:
	return ingredientData.icon

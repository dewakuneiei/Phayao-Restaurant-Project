extends Dish
class_name RawDish

var _ingredients : Array = []
var is_chopping = false

func interact(player: Player):
	super.interact(player)

func get_ingredients():
	return _ingredients

func set_ingredients(newIngredients: Array):
	_ingredients = newIngredients


func add_ingredient(id: int):
	_ingredients.append(id)
	if _ingredients.size() > 4:
		_ingredients.resize(4)
		return false
	return true

func get_all_keys() -> Array:
	return _ingredients

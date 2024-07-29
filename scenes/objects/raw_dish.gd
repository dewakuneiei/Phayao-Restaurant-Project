extends Dish
class_name RawDish

var _ingredients : Array = []

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

func reset_key():
	_ingredients.clear()
	_remove_children_from_third()

func _remove_children_from_third():
	while get_child_count() > 2:
		var child = get_child(2)
		remove_child(child)
		child.queue_free()

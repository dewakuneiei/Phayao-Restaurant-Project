class_name FoodData

var value: int
var icon: Texture

var _food_name: StringName

func _init(
	food_name: StringName,
	initial_value: int = 0,
	initial_icon: Texture = null):
	
	value = initial_value
	_food_name = food_name.to_upper()

	if initial_icon != null: icon = initial_icon

func get_name() -> StringName:
	return _food_name

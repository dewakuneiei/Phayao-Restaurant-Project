class_name FoodData

var value: int
var icon: Texture
var _food_name: StringName
var _id: int

func _init(
	id: int,
	food_name: StringName,
	initial_value: int = 0,
	initial_icon: Texture = null):
	value = initial_value
	_food_name = food_name.to_upper()
	_id = id
	if initial_icon: icon = initial_icon


func get_id() -> int:
	return _id

func get_name() -> StringName:
	return _food_name

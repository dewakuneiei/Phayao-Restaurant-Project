class_name FoodData

var value: int
var icon: Texture

var _eng_name: StringName
var _thai_name: StringName

func _init(
	thai_name: StringName,
	eng_name: StringName,
	initial_value: int = 0,
	initial_icon: Texture = null):
	
	value = initial_value
	_thai_name = thai_name
	_eng_name = eng_name

	if initial_icon != null: icon = initial_icon

func get_name() -> StringName:
	return _eng_name

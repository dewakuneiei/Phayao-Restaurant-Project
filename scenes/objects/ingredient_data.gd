class_name IngredientData
var _thai_name: StringName
var _eng_name: StringName
var amount: int
var price: int

func _init(eng_name: StringName, thai_name: StringName, initial_amount: int = 0, inital_price: int = 1):
	_thai_name = thai_name
	_eng_name = eng_name
	amount = initial_amount
	price = inital_price

func get_name() -> StringName:
	return _thai_name

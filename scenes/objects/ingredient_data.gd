class_name IngredientData

var _thai_name: StringName
var _eng_name: StringName
var amount: int
var price: int
var icon: Texture

func _init(
	eng_name: StringName,
	 thai_name: StringName,
	 initial_amount: int = 0,
	 initial_price: int = 1,
	initial_icon: Texture = null):
	
	_thai_name = thai_name
	_eng_name = eng_name
	amount = initial_amount
	price = initial_price
	if initial_icon != null: icon = initial_icon

func get_name() -> StringName:
	return _thai_name

func clone() -> IngredientData:
	return IngredientData.new(_thai_name, _eng_name, amount, price, icon)

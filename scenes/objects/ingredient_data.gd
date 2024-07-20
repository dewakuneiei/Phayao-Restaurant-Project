class_name IngredientData

var price: int
var icon: Texture
var _ingredient_name: StringName
var _id: int

func _init(
	id: int,
	ingredient_name: StringName,
	 initial_price: int = 1,
	initial_icon: Texture = null):
	
	_ingredient_name = ingredient_name.to_upper()
	_id = id
	price = initial_price
	
	if initial_icon: icon = initial_icon

func get_name() -> StringName:
	return _ingredient_name

func get_id() -> int:
	return _id
	
func clone() -> IngredientData:
	return IngredientData.new(_id,_ingredient_name, price, icon)


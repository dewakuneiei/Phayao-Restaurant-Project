extends Interactive
class_name Fridge

@export var _ui_inventoy: InventroyUI

# Create a dictionary to hold instances of IngredientData
#var inventory: Dictionary= {
	#"Fish": _gameSystem.IngredientData.new("Fish", "ปลา"),
	#"Pork": _gameSystem.IngredientData.new("Pork", "หมู"),
	#"Salt": _gameSystem.IngredientData.new("Salt", "เกลือ"),
	#"Chili": _gameSystem.IngredientData.new("Chili", "พริกขี้หนู"),
	#"Chicken": _gameSystem.IngredientData.new("Chicken", "ไก่"),
	#"Noodles": _gameSystem.IngredientData.new("Noodles", "เส้นข้าวซอย"),
	#"Lime": _gameSystem.IngredientData.new("Lime", "มะนาว"),
	#"Egg": _gameSystem.IngredientData.new("Egg", "ไข่ไก่"),
	#"Crab": _gameSystem.IngredientData.new("Crab", "ปูนา"),
#}

var inventory: Dictionary = {}

func interact(player: Player):
	if _ui_inventoy.visible: _ui_inventoy.deactivate(); return;
	_ui_inventoy.update_item_data(inventory)
	_ui_inventoy.activate()

func update_inventory(item: StringName, ingredientData: IngredientData):
	if inventory.has(item):
		print("Has it")


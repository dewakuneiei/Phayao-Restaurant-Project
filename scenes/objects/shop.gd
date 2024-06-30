extends Interactive
class_name Shop

@export var _shopUi: ShopUi
@export var _isMeatShop: bool

var _entry: Dictionary;


func _ready():
	
	_updated_entry()

func interact(player: Player):
	if _shopUi.visible: _shopUi.deactivate(); return;
	_shopUi.update_shop(_entry)
	_shopUi.activate()
	
func _updated_entry():
	var load_icons = GameSystem.load_icons
	if _isMeatShop:
		_entry = {
			"Fish": IngredientData.new("Fish", "ปลา", 1, 70, load_icons["Fish"]),
			"Pork": IngredientData.new("Port", "หมู", 1, 60, load_icons["Pork"]),
			"Chicken": IngredientData.new("Chicken", "ไก่", 1, 40, load_icons["Chicken"]),
			"Egg": IngredientData.new("Egg", "ไข่ไก่", 10, 50, load_icons["Egg"]),
			"Crab": IngredientData.new("Crab", "ปูนา", 3, 120, load_icons["Crab"])
		}
	else:
		_entry = {
			"Salt": IngredientData.new("Salt", "เกลือ", 10, 10, load_icons["Salt"]),
			"Chili": IngredientData.new("Chili", "พลิกขี้หนู", 10, 10, load_icons["Chili"]),
			"Noodles": IngredientData.new("Noodles", "เส้นข้าวซอย", 10, 10, load_icons["Noodles"]),
			"Lime": IngredientData.new("Lime", "มะนาว", 10, 10, load_icons["Lime"]),
		}
	
	

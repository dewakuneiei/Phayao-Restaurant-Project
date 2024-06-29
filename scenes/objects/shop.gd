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
	if _isMeatShop:
		_entry = {
			"Fish": IngredientData.new("Fish", "ปลา", 1, 70),
			"Pork": IngredientData.new("Port", "หมู", 1, 60),
			"Chicken": IngredientData.new("Chicken", "ไก่", 1, 40),
			"Egg": IngredientData.new("Egg", "ไข่ไก่", 10, 50),
			"Crab": IngredientData.new("Crab", "ปูนา", 3, 120)
		}
	else:
		_entry = {
			"Salt": IngredientData.new("Salt", "เกลือ", 10, 10),
			"Chili": IngredientData.new("Chili", "พลิกขี้หนู", 10, 10),
			"Noodles": IngredientData.new("Noodles", "เส้นข้าวซอย", 10, 10),
			"Lime": IngredientData.new("Lime", "มะนาว", 10, 10),
		}
	
	

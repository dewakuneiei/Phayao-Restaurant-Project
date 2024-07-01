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
		var fish = IngredientData.new(1, "Fish", "ปลา", 1, 70, load_icons["Fish"])
		var pork = IngredientData.new(2, "Pork", "หมู", 1, 60, load_icons["Pork"])
		var chicken = IngredientData.new(3,"Chicken", "ไก่", 1, 40, load_icons["Chicken"])
		var egg = IngredientData.new(4,"Egg", "ไข่ไก่", 10, 50, load_icons["Egg"])
		var crab = IngredientData.new(5,"Crab", "ปูนา", 3, 120, load_icons["Crab"])
		_entry = {
			1: fish,
			2: pork,
			3: chicken,
			4: egg,
			5: crab
		}
	else:
		var salt = IngredientData.new(6,"Salt", "เกลือ", 10, 10, load_icons["Salt"])
		var chili = IngredientData.new(7,"Chili", "พริกขี้หนู", 10, 10, load_icons["Chili"])
		var noodles = IngredientData.new(8,"Noodles", "เส้นข้าวซอย", 10, 10, load_icons["Noodles"])
		var lime = IngredientData.new(9,"Lime", "มะนาว", 10, 10, load_icons["Lime"])
		_entry = {
			6: salt,
			7: chili,
			8: noodles,
			9: lime
		}


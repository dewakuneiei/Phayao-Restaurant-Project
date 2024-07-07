extends Interactive
class_name Shop

@export var _shopUi: ShopUi
@export var _isMeatShop: bool
var _entry: Dictionary

func _ready():
	update_entry()

func interact(player: Player):
	if _shopUi.visible:
		_shopUi.deactivate()
		return
	_shopUi.update_shop(_entry)
	_shopUi.activate()

func update_entry():
	var load_icons = GameSystem.load_icons
	if _isMeatShop:
		var fish = IngredientData.new(1, "Fish", 3, 20, load_icons["Fish"])
		var pork = IngredientData.new(2, "Pork", 3, 20, load_icons["Pork"])
		var chicken = IngredientData.new(3, "Chicken", 3, 20, load_icons["Chicken"])
		var egg = IngredientData.new(4, "CHICKEN_EGG", 3, 20, load_icons["Egg"])
		var crab = IngredientData.new(5, "FIELD_CRAB", 3, 20, load_icons["Crab"])
		_entry = {
			1: fish,
			2: pork,
			3: chicken,
			4: egg,
			5: crab
		}
	else:
		var salt = IngredientData.new(6, "Salt", 5, 10, load_icons["Salt"])
		var chili = IngredientData.new(7, "Chili", 5, 10, load_icons["Chili"])
		var noodles = IngredientData.new(8, "RICE_NOODLE", 5, 10, load_icons["Noodles"])
		var lime = IngredientData.new(9, "Lime", 5, 10, load_icons["Lime"])
		var coriander = IngredientData.new(0, "Cilantro", 5, 10, load_icons["Coriander"])
		_entry = {
			6: salt,
			7: chili,
			8: noodles,
			9: lime,
			0: coriander
		}

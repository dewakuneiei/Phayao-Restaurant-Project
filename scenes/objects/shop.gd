extends Interactive
class_name Shop

@export var shop_ui: ShopUi
var entry: Dictionary

func _ready():
	populate_entry()

func interact(player: Player):
	if shop_ui.visible:
		shop_ui.deactivate()
	else:
		shop_ui.update_shop(entry)
		shop_ui.activate()

func populate_entry():
	var all_ingredients = GameManager.all_ingredients
	entry = {}
	for i in range(all_ingredients.size()):
		entry[i] = all_ingredients[i]

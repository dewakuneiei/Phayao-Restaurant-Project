extends Interactive
class_name Shop

@export var shop_ui: ShopUi
var entry: Dictionary
func _ready():
	populate_entry()
	shop_ui.update_shop(entry)

func interact(player: Player):
	if player.is_holding_dish(): return;
	if shop_ui.visible:
		shop_ui.deactivate()
	else:
		shop_ui.activate()

func populate_entry():
	var all_ingredients = GameManager.all_ingredients
	entry = {}
	for i in range(all_ingredients.size()):
		entry[i] = all_ingredients[i]


func _on_area_exited(area: Area2D):
	if area.get_parent() is Player:
		shop_ui.deactivate()
	

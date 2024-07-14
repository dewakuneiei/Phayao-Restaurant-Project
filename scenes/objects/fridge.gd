extends Interactive
class_name Fridge

@export var ui_inventory: FridgeUI
@onready var dishTemplate = preload("res://scenes/objects/ingredient_dish.tscn")
var inventory: Dictionary = {}

func interact(player: Player):
	if ui_inventory.visible:
		ui_inventory.deactivate()
		return
	ui_inventory.update_item_data(self, player, inventory)
	ui_inventory.activate()

func update_inventory(key, ingredientData: IngredientData):
	if inventory.has(key):
		inventory[key].amount += ingredientData.amount
	else:
		inventory[key] = ingredientData.clone()

func decrease_item(key, item: IngredientData):
	item.amount -= 1
	if item.amount < 1:
		inventory.erase(key)

func take_to_player(player:Player, key):
	if not inventory.has(key): return
	var item: IngredientData = inventory[key]
	var dish = player.get_dish()
	if dish and dish is RawDish:        
		if dish.add_ingredient(key):
			decrease_item(key, item)
			var new_sprite = Sprite2D.new()
			new_sprite.texture = item.icon
			new_sprite.rotation_degrees = randf_range(0, 360)
			new_sprite.flip_h = randf() > 0.5
			dish.add_child(new_sprite)
			
	elif dish == null:
		var new_dish = dishTemplate.instantiate()
		if new_dish is Dish:
			new_dish.set_sprite_texture(item.icon)
			new_dish.ingredient_id = item.get_id()
			player.take_item(new_dish)
			decrease_item(key, item)
	
	ui_inventory.update_item_data(self, player, inventory)

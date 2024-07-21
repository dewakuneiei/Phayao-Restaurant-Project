extends Interactive
class_name Fridge

@export var ui_storage: FridgeUI
@onready var stream = preload("res://assets/sfx/freezer-door.mp3")
@onready var dishTemplate = preload("res://scenes/objects/ingredient_dish.tscn")
var storage: Dictionary = {}

func interact(player: Player):
	play_sound(stream)
	if ui_storage.visible:
		ui_storage.deactivate()
		return

	var dish = player.get_dish()
	if dish is Box:
		
		var box = player.transfer_dish() as Box
		var basket = box.basket
		update_storage(basket)
		box.queue_free()
		return
	elif dish is IngredientDish:
		insert_ingredient(dish.ingredientData)
		player.transfer_dish().queue_free()
		return
	
	ui_storage.activate()
	ui_storage.update_item_data(self, player, storage)

func update_storage(basket: Dictionary):
	for key in basket.keys():
		var data = basket[key][0]
		var amount = basket[key][1]
		if storage.has(key):
			print(storage[key][1])
			storage[key][1] += amount
		else:
			storage[key] = [data, amount]

func insert_ingredient(data: IngredientData):
	var key = data.get_id()
	if storage.has(key):
		storage[key][1] += 1
	else:
		storage[key] = [data, 1]

func decrease_item(key):
	var slot = storage[key]
	slot[1 as int] -= 1
	if slot[1 as int] < 1:
		storage.erase(key)

func take_to_player(player:Player, key):
	if not storage.has(key): return
	var item: IngredientData = storage[key][0]
	var dish = player.get_dish()
	if dish and dish is RawDish:        
		if dish.add_ingredient(key):
			decrease_item(key)
			var new_sprite = Sprite2D.new()
			new_sprite.texture = item.icon
			new_sprite.rotation_degrees = randf_range(0, 360)
			new_sprite.flip_h = randf() > 0.5
			new_sprite.scale = Vector2i.ONE * 1.5
			dish.add_child(new_sprite)
			
	elif dish == null:
		var new_dish = dishTemplate.instantiate() as IngredientDish
		new_dish.set_sprite_texture(item.icon)
		new_dish.ingredientData = item
		player.take_item(new_dish)
		decrease_item(key)
	
	ui_storage.update_item_data(self, player, storage)

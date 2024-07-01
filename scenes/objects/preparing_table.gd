extends Interactive
class_name PreparingTable

@onready var dishTemplate = preload("res://scenes/objects/raw_dish.tscn")
@onready var mark: Marker2D = $DishMark

var task : Dish= null

func interact(player: Player):
	var is_holding_dish : bool = player.is_holding_dish()
	
	#mix dish
	if task != null and task.is_in_group("raw_dish") and is_holding_dish:
		var other_item : Dish= player.transfer_dish()
		if not other_item.is_in_group("raw_dish") and task is RawDish:
			task = task as RawDish
			### work here add make id in
			task.add_ingredient(other_item.ingredient_id)
			var new_sprite = create_sprite(other_item.get_texutre())
			task.add_child(new_sprite)
			
	elif task != null and not task.is_in_group("raw_dish") and is_holding_dish:
		var dish = player.get_dish()
		if dish != null and dish is RawDish and task is Dish:
			var new_sprite = create_sprite(task.get_texutre())
			dish.add_ingredient(task.ingredient_id)
			dish.add_child(new_sprite)
			task.queue_free()
			task = null

	elif task != null and task.is_in_group("dish") and not is_holding_dish:
		mark.remove_child(task)
		player.take_item(task)
		task = null
		
	# transfer
	elif task == null and is_holding_dish:
		task = player.transfer_dish()
		mark.add_child(task)
	#create new dish
	elif task == null:
		
		var new_dish = dishTemplate.instantiate()
		mark.add_child(new_dish)
		task = new_dish
	
func create_sprite(txture: Texture):
	var new_sprite = Sprite2D.new()
	new_sprite.texture = txture
	new_sprite.rotation_degrees = randf_range(0, 360)
	new_sprite.flip_h = randf() > 0.5
	return new_sprite

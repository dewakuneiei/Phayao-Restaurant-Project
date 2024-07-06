extends Interactive
class_name PreparingTable

@onready var dish_template = preload("res://scenes/objects/raw_dish.tscn")
@onready var mark: Marker2D = $DishMark
var task: Dish = null

func interact(player: Player):
	var is_holding_dish: bool = player.is_holding_dish()
	
	if task:
		handle_existing_task(player, is_holding_dish)
	elif is_holding_dish:
		transfer_dish_from_player(player)
	else:
		create_new_dish()

func handle_existing_task(player: Player, is_holding_dish: bool):
	if task.is_in_group("raw_dish") and not task.is_in_group("food_dish") and is_holding_dish:
		mix_ingredients(player)
	elif not task.is_in_group("raw_dish") and not task.is_in_group("food_dish") and is_holding_dish:
		add_ingredient_to_player_dish(player)
	elif task.is_in_group("dish") and not is_holding_dish:
		give_dish_to_player(player)

func mix_ingredients(player: Player):
	var other_item: Dish = player.transfer_dish()
	if not other_item.is_in_group("raw_dish") and task is RawDish:
		var raw_task := task as RawDish
		raw_task.add_ingredient(other_item.ingredient_id)
		raw_task.add_child(create_sprite(other_item.get_texutre()))

func add_ingredient_to_player_dish(player: Player):
	var dish = player.get_dish()
	if dish is RawDish and task is Dish:
		dish.add_ingredient(task.ingredient_id)
		dish.add_child(create_sprite(task.get_texutre()))
		task.queue_free()
		task = null

func give_dish_to_player(player: Player):
	mark.remove_child(task)
	player.take_item(task)
	task = null

func transfer_dish_from_player(player: Player):
	task = player.transfer_dish()
	mark.add_child(task)

func create_new_dish():
	var new_dish = dish_template.instantiate()
	mark.add_child(new_dish)
	task = new_dish

func create_sprite(texture: Texture) -> Sprite2D:
	var new_sprite = Sprite2D.new()
	new_sprite.texture = texture
	new_sprite.rotation_degrees = randf_range(0, 360)
	new_sprite.flip_h = randf() > 0.5
	return new_sprite

func _ready():
	set_process(false)
	set_physics_process(false)
	set_process_input(false)

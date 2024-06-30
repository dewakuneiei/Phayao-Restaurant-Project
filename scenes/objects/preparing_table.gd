extends Interactive
class_name PreparingTable

@onready var dishTemplate = preload("res://scenes/objects/dish.tscn")
@onready var mark: Marker2D = $DishMark

var task: Dish = null

func interact(player: Player):
	var is_holding_dish : bool = player.is_holding_dish()
	
	#take to player hand
	if task != null and task.is_in_group("dish") and not is_holding_dish:
		var clone = task.duplicate()
		player.take_item(clone)
		task.queue_free()
		
		#new_dish.position = mark.position
	elif task == null and is_holding_dish:
		# transfer
		task = player.transfer_dish()
		mark.add_child(task)
	#create new dish
	elif task == null:
		
		var new_dish = dishTemplate.instantiate()
		mark.add_child(new_dish)
		task = new_dish
	


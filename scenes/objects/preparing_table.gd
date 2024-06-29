extends Interactive
class_name PreparingTable

@onready var dish = preload("res://assets/sprites/dish.png")
@onready var mark: Marker2D = $DishMark

func interact(player: Player):
	if player.is_preparing_dish:
		return
	
	if mark.get_child_count() > 0:
		pass
	else:
		var new_dish = Sprite2D.new()
		new_dish.texture = dish
		mark.add_child(new_dish)
		new_dish.scale = Vector2.ONE * 2.1
	


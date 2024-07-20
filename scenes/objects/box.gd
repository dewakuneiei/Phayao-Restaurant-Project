extends Dish
class_name Box

var basket: Dictionary

func set_collistion(enable: bool):
	$CollisionShape2D.disabled = not enable
	$StaticBody2D/CollisionShape2D.disabled = not enable



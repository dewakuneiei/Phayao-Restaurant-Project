extends Area2D
class_name Interactive

@export var interact_name: StringName;

func interact(player: Player):
	print("Player interact with "+ interact_name)
	pass

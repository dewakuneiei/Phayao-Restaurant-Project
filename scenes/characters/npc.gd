extends Area2D
class_name NPC

var move_speed: float = 100.0  # pixels per second

func set_move_to_target(target: Vector2):
	var distance = global_position.distance_to(target)
	var duration = distance / move_speed
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", target, duration)
	tween.tween_callback(Callable(self, "_on_movement_completed"))

func _on_movement_completed():
	print("Reached the target position")

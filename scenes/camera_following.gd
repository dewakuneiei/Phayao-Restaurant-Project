extends Camera2D

@export var follow_object: Node2D
@export var smoothing_speed: float = 5.0

func _process(delta: float) -> void:
	if follow_object:
		var target_position = follow_object.global_position
		global_position = global_position.lerp(target_position, smoothing_speed * delta)

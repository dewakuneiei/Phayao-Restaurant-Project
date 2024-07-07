extends Marker2D


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	set_physics_process(false)
	set_process_input(false)

func _on_area_2d_area_entered(area):
	if area is Customer:
		if not area.is_none_state():
			area.queue_free()

extends Control
class_name RecipeUI

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	set_process_input(false)
	set_physics_process(false)
	set_process_unhandled_input(false)
	hide()

func _on_close_pressed():
	hide()

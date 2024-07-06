extends Control
class_name FoodRecipes

func _ready():
	set_process(false)
	set_process_input(false)
	set_physics_process(false)
	self.hide()  # Start hidden

func toggle():
	visible = !visible  # Toggle visibility

func _on_button_pressed():
	toggle()

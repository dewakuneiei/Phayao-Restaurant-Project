extends Control  # Assuming this script is attached to a Control node
class_name FridgeUI

@onready var container = %ItemContainer
@onready var style: StyleBoxTexture = preload("res://new_stylebox.tres")
@onready var depth_style: StyleBoxTexture = preload("res://new_depth_stylebox.tres")

func _ready():
	deactivate()
	pass

func remove_all_children():
	for child in container.get_children():
		container.remove_child(child)

func update_item_data(fridge: Fridge, player: Player, storage: Dictionary):
	remove_all_children()
	
	for key in storage.keys():
		var new_button = Button.new()
		container.add_child(new_button)
		var ingredient = storage[key][0] as IngredientData
		var amount = storage[key][1]
		
		new_button.icon = ingredient.icon
		new_button.text = "%s x%d" % [ingredient.get_name(), amount]
		new_button.pressed.connect(func(): fridge.take_to_player(player, key))
		
		# Set the button styles
		new_button.add_theme_stylebox_override("normal", depth_style)
		new_button.add_theme_stylebox_override("hover", depth_style)
		new_button.add_theme_stylebox_override("pressed", style)
		
		# Remove the focus stylebox by setting it to an empty StyleBoxEmpty
		var empty_style = StyleBoxEmpty.new()
		new_button.add_theme_stylebox_override("focus", empty_style)
		
		# Set the text color to black for all button states
		new_button.add_theme_color_override("font_color", Color.BLACK)
		new_button.add_theme_color_override("font_pressed_color", Color.BLACK)
		new_button.add_theme_color_override("font_hover_color", Color.BLACK)
		new_button.add_theme_color_override("font_focus_color", Color.BLACK)
		new_button.add_theme_color_override("font_hover_pressed_color", Color.BLACK)
		new_button.add_theme_color_override("font_disabled_color", Color.BLACK)

func deactivate():
	hide()  # Hide the node visually
	set_process(false)  # Stop processing
	set_physics_process(false)  # Stop physics processing
	set_process_unhandled_input(false)  # Stop unhandled input processing
	set_process_input(false)  # Stop input processing

func activate():
	show()  # Show the node visually
	set_process(true)  # Resume processing
	set_physics_process(true)  # Resume physics processing
	set_process_unhandled_input(true)  # Resume unhandled input processing
	set_process_input(true)  # Resume input processing


func _on_close_btn_pressed():
	deactivate()

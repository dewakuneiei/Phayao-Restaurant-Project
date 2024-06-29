extends Control  # Assuming this script is attached to a Control node
class_name InventroyUI

const template = preload("res://scenes/GUI/ui_item.tscn")

@onready var container = %ItemContainer

var player:Player

func _ready():
	deactivate()
	pass

func update_item_data(inventory: Dictionary):
	for key in inventory.keys():
		var item: IngredientData = inventory[key]
		print(item.get_name())

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

extends Control  # Assuming this script is attached to a Control node
class_name InventroyUI

const template = preload("res://scenes/GUI/ui_item.tscn")

@onready var container = %ItemContainer

func _ready():
	deactivate()
	pass

func remove_all_children():
	for child in container.get_children():
		container.remove_child(child)

func update_item_data(fridge: Fridge, player: Player, inventory: Dictionary):
	remove_all_children()
	for key in inventory.keys():
		var new_item = template.instantiate()
		container.add_child(new_item)
		
		if new_item is ItemUi:
			var ingredient : IngredientData = inventory[key]
			new_item.amount_l.text = "x"+ str(ingredient.amount)
			new_item.name_l.text = ingredient.get_name()
			
			var btn : TextureButton = new_item.btn
			btn.texture_normal = ingredient.icon
			new_item.btn.pressed.connect(func(): 
				print("Clicked ที่กับข้าวในตู้เย็น")
				if player.is_holding_dish(): return;
				fridge.take_to_player(player, key)
				)

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

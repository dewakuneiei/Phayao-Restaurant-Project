extends Control
class_name ShopUi

const template = preload("res://scenes/GUI/ui_shop_item.tscn") 

@onready var entryContainer = %EntryContainer
@onready var money_l = %Money

var gameSystem : GameSystem

func _ready():
	deactivate()

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

func remove_all_children():
	for child in entryContainer.get_children():
		entryContainer.remove_child(child)

func update_shop(entry: Dictionary):
	if gameSystem == null: gameSystem = GameSystem.instance;
	
	remove_all_children()
	_update_money()
	for key in entry.keys():
		var new_entry = template.instantiate()
		entryContainer.add_child(new_entry)
		
		if new_entry is ShopItemUi:
			var item : IngredientData = entry[key] as IngredientData
			var price = item.price;
			new_entry.name_l.text = item.get_name()
			new_entry.price_l.text = str(price) + " B"
			new_entry.amount_l.text = "x"+ str(item.amount)
			new_entry.rect.texture = item.icon
			
			var buyBtn : Button = new_entry.buy_btn
			buyBtn.pressed.connect(func(): 
				if gameSystem.get_money() - price < 0: return;
				gameSystem.spend_money(price)
				_update_money()
				gameSystem.fridge.update_inventory(key, item)
				)

func _update_money():
	money_l.text = "Money: " + str(gameSystem.get_money()) + " B"

func _on_close_pressed():
	deactivate()

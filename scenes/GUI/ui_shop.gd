extends Control
class_name ShopUi

const CURRENCY = "BAHT"

@onready var template = preload("res://scenes/GUI/ui_shop_item.tscn") 
@onready var boxTemplate = preload("res://scenes/objects/box.tscn")
@onready var entryContainer = %ItemContainer
@onready var money_l = %Money
@onready var total_l = %Total

var entry: Dictionary

var basket: Dictionary
var total: int = 0

func _ready():
	deactivate()
	%Close.connect("pressed", _on_close_pressed)
	%Page1.connect("pressed", _on_page_1_pressed)
	%Page2.connect("pressed", _on_page_2_pressed)
	%Buy.connect("pressed", _on_buy_pressed)

func deactivate():
	hide()
	reset_basket()
	set_process(false)
	set_physics_process(false)
	set_process_unhandled_input(false)
	set_process_input(false)

func activate():
	show()
	set_process(true)
	set_physics_process(true)
	set_process_unhandled_input(true)
	set_process_input(true)

func show_with_page(page_no: int):
	var start_key = 0 if page_no == 1 else 5
	var end_key = 4 if page_no == 1 else 9
	
	for index in range(entryContainer.get_child_count()):
		var item = entryContainer.get_child(index) as ShopItemUi
		if index >= start_key and index <= end_key and item:
			item.show()
		else:
			item.hide()

func update_shop(newEntry: Dictionary):
	entry = newEntry
	
	var child_index = 0
	for key in entry.keys():  # Assuming there are always 10 potential items
		var item = entry.get(key) as IngredientData
		var shop_item_ui: ShopItemUi
		
		if child_index < entryContainer.get_child_count():
			shop_item_ui = entryContainer.get_child(child_index) as ShopItemUi
		else:
			shop_item_ui = template.instantiate() as ShopItemUi
			entryContainer.add_child(shop_item_ui)
		shop_item_ui.setup(item)
		shop_item_ui.updated_amount.connect(update_total)
		child_index += 1
	update_money()
	show_with_page(1)

func update_money():
	if money_l:
		money_l.text = "Money: " + str(GameManager.money) + " " +CURRENCY

func update_total(data:IngredientData, amount: int):
	var key = data.get_id()
	if amount > 0 and basket.has(key) :
		basket[key][1] = amount
	elif amount > 0:
		basket[key] = [data, amount]
	else:
		basket.erase(key)
	
	total = 0
	for item in basket.values():
		var value = item[0].price * item[1] 
		total += value
	total_l.modulate = Color.RED if total > 0 else Color.WHITE
	total_l.text = "TOTAL: "+ str(total) + " " + CURRENCY

func reset_basket():
	basket.clear()
	for child in entryContainer.get_children():
		if child is ShopItemUi:
			child.reset()

func _on_close_pressed():
	deactivate()

func _on_page_1_pressed():
	show_with_page(1)


func _on_page_2_pressed():
	show_with_page(2)

func _on_buy_pressed():
	if basket.is_empty(): deactivate(); return;
	
	var money = GameManager.money
	if (money - total) < 0: return
	var newBox = boxTemplate.instantiate() as Box
	var player = GameSystem.instance.player as Player
	
	if player:
		newBox.basket = basket.duplicate()
		player.take_item(newBox)
		GameManager.update_money(-total)
	update_money()
	deactivate()

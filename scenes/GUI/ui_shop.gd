extends Control
class_name ShopUi

const CURRENCY = "BAHT"

@onready var template = preload("res://scenes/GUI/ui_shop_item.tscn") 
@onready var boxTemplate = preload("res://scenes/objects/box.tscn")
@onready var buying_stream = preload("res://assets/sfx/lever.wav")
@onready var default_stream = preload("res://assets/sfx/ui/MI_SFX 42.mp3")
@onready var entryContainer = %ItemContainer
@onready var money_l = %Money
@onready var total_l = %Total

var entry: Dictionary

var basket: Dictionary
var total: int = 0

func _ready():
	deactivate()
	
	total_l.text = "%s: %d %s" % [tr("TOTAL"), total, tr(CURRENCY) ]
	money_l.text = "%s: %d %s" % [tr("MONEY"), GameManager.money, tr(CURRENCY) ]
	total_l.add_theme_color_override("font_color", Color.DIM_GRAY)
	
	%Close.connect("pressed", _on_close_pressed)
	%Page1.connect("pressed", _on_page_pressed.bind(true))
	%Page2.connect("pressed", _on_page_pressed.bind(false))
	%Buy.connect("pressed", _on_buy_pressed)
	%Clear.connect("pressed", _on_clear_pressed)

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

func show_with_page(is_page_1: bool):
	var start_key = 0 if is_page_1 else 5
	var end_key = 4 if is_page_1 else 9
	
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
		money_l.text = "%s: %d %s" % [tr("MONEY"), GameManager.money, tr(CURRENCY) ]
		money_l.add_theme_color_override("font_color", Color.DIM_GRAY)

func update_total(data:IngredientData, amount: int):
	var money = GameManager.money
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
	if total > money:
		total_l.add_theme_color_override("font_color", Color.ORANGE_RED)
	else:
		total_l.add_theme_color_override("font_color", Color.DIM_GRAY)
	total_l.text = "%s: %d %s" % [tr("TOTAL"), total, tr(CURRENCY) ]

func reset_basket():
	basket.clear()
	for child in entryContainer.get_children():
		if child is ShopItemUi:
			child.reset()

func _on_close_pressed():
	deactivate()
	GameManager.play_sfx_with_stream(default_stream)

func _on_page_pressed(is_page_1: bool):
	GameManager.play_sfx_with_stream(default_stream)
	show_with_page(is_page_1)

func _on_clear_pressed():
	GameManager.play_sfx_with_stream(default_stream)
	reset_basket()

func _on_buy_pressed():
	GameManager.play_sfx_with_stream(default_stream)
	if basket.is_empty(): return;
	var money = GameManager.money
	if (money - total) < 0: return
	var newBox = boxTemplate.instantiate() as Box
	var player = GameSystem.instance.player as Player
	
	if player:
		newBox.basket = basket.duplicate()
		player.take_item(newBox)
		GameManager.update_money(-total)
		GameManager.play_sfx_with_stream(buying_stream)
		update_money()
		deactivate()

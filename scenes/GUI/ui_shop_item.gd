extends Control
class_name ShopItemUi

signal updated_amount(ingredientData: IngredientData, amount: int)

@onready var name_l : Label = %name_l
@onready var price_l : Label = %price_l
@onready var number_l: Label = %number
@onready var decrease_btn : Button = %Decrease
@onready var increase_btn: Button = %Increase
@onready var rect : TextureRect = $TextureRect

var amount: int = 0
var ingredientData: IngredientData

func _ready():
	set_process(false)
	update_number_display()
	decrease_btn.connect("pressed", on_decrease_pressed)
	increase_btn.connect("pressed", on_increase_pressed)

func setup(ingredientData: IngredientData):
	self.ingredientData = ingredientData
	name_l.text = ingredientData.get_name()
	price_l.text = str(ingredientData.price) + " B"
	rect.texture = ingredientData.icon
	update_number_display()

func on_increase_pressed():
	amount = clampi(amount + 1, 0, 10)
	update_number_display()

func on_decrease_pressed():
	amount = clampi(amount - 1, 0, 10)
	update_number_display()
	

func reset():
	amount = 0
	update_number_display()

func update_number_display():
	updated_amount.emit(ingredientData, amount)
	if number_l:
		number_l.text = str(amount)

extends Control
class_name ShopItemUi

signal updated_amount(ingredientData: IngredientData, amount: int)

@onready var name_l : Label = %name_l
@onready var price_l : Label = %price_l
@onready var number_l: Label = %number
@onready var decrease_btn : Button = %Decrease
@onready var increase_btn: Button = %Increase
@onready var decrease5_btn: Button = %Decrease5
@onready var increase5_btn: Button = %Increase5
@onready var rect : TextureRect = $TextureRect
@onready var stream = preload("res://assets/sfx/ui/MI_SFX 49.mp3")

var amount: int = 0
var ingredientData: IngredientData

func _ready():
	set_process(false)
	update_number_display()
	decrease_btn.connect("pressed", update_amount_value.bind(-1))
	increase_btn.connect("pressed", update_amount_value.bind(1))
	decrease5_btn.connect("pressed", update_amount_value.bind(-5))
	increase5_btn.connect("pressed", update_amount_value.bind(5))

func setup(ingredientData: IngredientData):
	self.ingredientData = ingredientData
	name_l.text = ingredientData.get_name()
	price_l.text = str(ingredientData.price) + " B"
	rect.texture = ingredientData.icon
	update_number_display()

func update_amount_value(value: int):
	GameManager.play_sfx_with_stream(stream)
	amount = clampi(amount + value, 0, 100)
	update_number_display()

func reset():
	amount = 0
	update_number_display()

func update_number_display():
	updated_amount.emit(ingredientData, amount)
	if number_l:
		number_l.text = str(amount)

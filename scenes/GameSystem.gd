extends Node
class_name GameSystem

static var instance: GameSystem
static var load_icons: Dictionary = {
	"Fish": load("res://assets/sprites/ingredients/fish.png"), 
	"Pork": load("res://assets/sprites/ingredients/pork.png"), 
	"Salt": load("res://assets/sprites/ingredients/salt.png"),
	"Chili": load("res://assets/sprites/ingredients/chili.png"), 
	"Chicken": load("res://assets/sprites/ingredients/chicken.png"), 
	"Noodles": load("res://assets/sprites/ingredients/noodles.png"), 
	"Lime": load("res://assets/sprites/ingredients/lime.png"), 
	"Egg": load("res://assets/sprites/ingredients/egg.png"), 
	"Crab": load("res://assets/sprites/ingredients/crab.png"),
	"Coriander": load("res://assets/sprites/ingredients/coriander.png") 
}

@export_category("refference")
@export var player: Player
@export var fridge: Fridge
@export var shop1: Shop
@export var shop2: Shop
@export var recipes: FoodRecipes
@export var counter: Counter

@onready var unknown_menu: FoodData = FoodData.new("ไม่รู้จัก", "Unknown", 50, load("res://assets/sprites/foods/food.png"))
@onready var chicken_khao_soi: FoodData = FoodData.new("ข้าวซอยไก่", "Chicken Khao Soi", 50, load("res://assets/sprites/foods/food.png"))
@onready var khai_pam: FoodData = FoodData.new("ไข่ป่าม", "Khai Pam", 75, load("res://assets/sprites/foods/food.png"))
@onready var ong_pu_na: FoodData = FoodData.new("อ่องปูนา", "Ong Pu Na", 125, load("res://assets/sprites/foods/food.png"))
@onready var aeb_pla_nil: FoodData = FoodData.new("แอ๊บปลานิล", "Aeb Pla Nil", 75, load("res://assets/sprites/foods/food.png"))
@onready var lon_pla_som :FoodData = FoodData.new("หลนปลาส้มพะเยา", "Lon Pla Som Phayao", 70, load("res://assets/sprites/foods/food.png"))

var _money: int

func _ready():
	instance = self
	earn_money(1000)

func spend_money(amount: float):
	_money -= amount
	if _money < 0:
		_money = 0

func earn_money(amount: float):
	_money += amount

func get_money():
	return _money

func get_all_food_menus() -> Array[FoodData]:
	return [chicken_khao_soi, khai_pam, ong_pu_na, aeb_pla_nil, lon_pla_som]

func get_random_food_menu() -> FoodData:
	var all_menus = get_all_food_menus()
	var random_index = randi() % all_menus.size()
	return all_menus[random_index]

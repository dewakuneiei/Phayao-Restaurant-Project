extends Interactive
class_name CookingTable

enum CookingState {
	FREE,
	COOKING,
	FINISHED,
}
@onready var _dish_template = preload("res://scenes/objects/food_dish.tscn")
@onready var _prgbar: TextureProgressBar = $TextureProgressBar

@export var cook_duration = 5
@export var overheat_duration = 5

var is_overheat = false
var gameSystem: GameSystem

var _state = CookingState.FREE
var _heat_time = 0

var what_cooking: FoodData

func interact(player: Player):
	if _state == CookingState.FINISHED:
		if what_cooking:
			var new_food_dish : FoodDish = _create_food_dish()
			player.take_item(new_food_dish)
		_prgbar.hide()
		_state = CookingState.FREE
	

	if _state != CookingState.FREE: print(55); return
	var dish = player.get_dish() as RawDish
	if dish is RawDish:
		var keys = dish.get_all_keys()
		if keys:
			player.destroy_dish()
			cooked(keys)


func _ready():
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	
	gameSystem = GameSystem.instance

func _process(delta):
	_prgbar.value += delta
	if _state == CookingState.COOKING and _prgbar.value >= _prgbar.max_value:
		finished()
	
	if not _state == CookingState.FINISHED: return
	
	if _heat_time >= overheat_duration:
		is_overheat = true
		print("Overheat")
		set_process(false)
	else:
		_heat_time += delta

func _create_food_dish() -> FoodDish:
	var new_food_dish = _dish_template.instantiate() as FoodDish
	new_food_dish.food_data = what_cooking
	new_food_dish.set_sprite_texture(what_cooking.icon)
	new_food_dish.set_text_label(what_cooking.get_name())
	return new_food_dish

func _match_food_data(keys: Array) -> FoodData:
	return FoodData.new("ไทย", "Eng");

func finished():
	_state = CookingState.FINISHED

func cooked(keys: Array):
	is_overheat = false
	what_cooking = _match_food_data(keys)
	
	_state = CookingState.COOKING
	_heat_time = 0
	_prgbar.show()
	_prgbar.value = 0
	_prgbar.max_value = cook_duration
	set_process(true)

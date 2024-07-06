extends Area2D
class_name Customer

var order_food: FoodData
var move_speed: float = 100.0  # pixels per second

var _gameSystem: GameSystem
var _counter: Counter

@onready var _control: Control = $Control
@onready var _label: Label = $Control/Label

func _ready():
	set_process(true)
	set_physics_process(false)

func _process(delta):
	_gameSystem = GameSystem.instance
	if _gameSystem:
		_counter = _gameSystem.counter
		if _counter:
			sent_order_request()
			set_process(false)

func sent_order_request():
	order_food = _gameSystem.get_random_food_menu()
	_label.text = order_food.get_name()
	_counter.add_to_queue(self)
	

func set_move_to_target(target: Vector2):
	print(target)
	var distance = global_position.distance_to(target)
	var duration = distance / move_speed
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", target, duration)
	tween.tween_callback(Callable(self, "_on_movement_completed"))

func pay_food(foodData: FoodData):
	if foodData == order_food:
		print("Great")
	else:
		print("Bad!")

func _on_movement_completed():
	print("Reached the target position")

func _on_mouse_entered():
	_control.show()


func _on_mouse_exited():
	_control.hide()

extends NPC
class_name Customer

enum CustomerState {NONE, REQUEST, WAITING, FINISHED}

const MAX_WAITING = 60

@onready var _control: Control = $Control
@onready var _label: Label = $Control/Label

var order_food: FoodData

var _gameSystem: GameSystem
var _counter: Counter
var _timer: float = 0
var _is_good = true
var _state: CustomerState = CustomerState.NONE

func _ready():
	set_process(true)
	set_physics_process(false)
	_timer = 0
	_is_good = true

func _process(delta):
	if _state == CustomerState.NONE:
		_timer += delta
		if _timer >= 3:
			_timer = 0
			sent_order_request()
	elif  _state == CustomerState.WAITING:
		_timer += delta
		if _timer >= MAX_WAITING:
			_timer = 0
			_is_good = false
			_label.text += "\n Bad!"
			set_process(false)
	elif _state == CustomerState.FINISHED:
		set_process(false)

func sent_order_request():
	_gameSystem = GameSystem.instance
	if _gameSystem:
		_counter = _gameSystem.counter
	
	order_food = _gameSystem.get_random_food_menu()
	_state = CustomerState.REQUEST
	_label.text = order_food.get_name()
	_counter.add_to_queue(self)
	

func pay_food(foodData: FoodData):
	_state = CustomerState.FINISHED
	set_move_to_target(_gameSystem.endPoint.global_position)
	feed_back(order_food == foodData)

func feed_back(is_it_right_food: bool):
	# right food and less wating
	if is_it_right_food and _is_good:
		GameManager.increase_rating()
	#not right food and less wating
	elif not is_it_right_food and _is_good:
		GameManager.decrease_rating()
	#right food but much wating
	elif is_it_right_food and not _is_good:
		GameManager.decrease_rating()
	#all are bad 
	else:
		GameManager.decrease_rating()
		GameManager.decrease_rating()
func is_none_state() -> bool:
	return _state == CustomerState.NONE

func _on_movement_completed():
	if order_food and _state == CustomerState.REQUEST:
		_state = CustomerState.WAITING

func _on_mouse_entered():
	_control.show()


func _on_mouse_exited():
	_control.hide()

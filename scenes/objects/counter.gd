extends Interactive
class_name Counter

signal player_entered(player: Player)
signal player_exited(player: Player)

const QUEUE_DISTANCE: int = 46

@export var coin_sound: AudioStream
@export var door_bell_sound: AudioStream

@onready var start_queue: Marker2D = %StartQeue
@onready var label: Label = $Label
@onready var anim_player: AnimationPlayer = $AnimationPlayer

var queue: Array[Customer] = []

func _ready() -> void:
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)
	label.hide()

func interact(player: Player) -> void:
	var customer := queue.front() as Customer
	
	if customer and customer.is_waiting():
		process_order(player, customer)
	if GameManager.is_game_started():
		return
	GameSystem.instance.ui_gameplay.open_btn.pressed.emit()

func update_queue() -> void:
	if queue.is_empty():
		return
	
	for i in queue.size():
		var target = start_queue.global_position + (Vector2.LEFT * i * QUEUE_DISTANCE)
		queue[i].set_move_to_target(target)

func add_to_queue(customer: Customer) -> void:
	queue.push_back(customer)
	update_queue()

func remove_from_queue(customer: Customer) -> void:
	queue.erase(customer)
	update_queue()

func earn_money(value: int) -> void:
	GameManager.update_money(value)
	label.text = "+%d" % value
	anim_player.play("earn_money")
	play_sound(coin_sound)

func process_order(player: Player, customer: Customer) -> void:
	var food := player.get_dish() as FoodDish
	if food and not queue.is_empty():
		var food_data := food.food_data as FoodData
		GameManager.update_log(food_data)
		customer.pay_food(food_data)
		remove_from_queue(customer)
		player.destroy_dish()
		earn_money(food_data.value)

func _on_body_entered(body: Node) -> void:
	if not body is Player: return
	player_entered.emit(body)
	#var customer := queue.front() as Customer
	#
	#if customer and customer.is_waiting():
		#var food := player.get_dish() as FoodDish
		#if food and not queue.is_empty():
			#_process_order(player, customer, food)
	#
	if not GameManager.is_game_started():
		GameSystem.instance.ui_gameplay.open_btn.show()

func _on_body_exited(body: Node) -> void:
	if body is Player: player_exited.emit(body)
	
	if not GameManager.is_game_started():
		GameSystem.instance.ui_gameplay.open_btn.hide()

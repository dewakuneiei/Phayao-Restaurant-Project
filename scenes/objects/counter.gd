extends Interactive
class_name Counter

const QUEUE_DISTANCE: int = 45

@export var gameSystem: GameSystem
@onready var start_queue: Marker2D = $StartQeue
@onready var label: Label = $Label
@onready var anim_player: AnimationPlayer = $AnimationPlayer

var queue: Array[Customer] = []

func _ready():
	initialize()

func initialize():
	gameSystem = gameSystem if gameSystem else GameSystem.instance
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)
	label.hide()

func interact(player: Player):
	if gameSystem.ui_recipt.visible:
		gameSystem.ui_recipt.hide()
		return
	
	if queue.is_empty():
		return
	
	var front_customer = queue.front()
	if front_customer.is_waiting():
		gameSystem.ui_recipt.show()

func update_queue():
	if queue.is_empty():
		return
	
	var front_customer = queue.front()
	var food_name = front_customer.order_food.get_name()
	var ingredient_arr = Recipe.get_ingredient_ids_for_food(food_name)
	print("Ingredient Array: ", ingredient_arr)
	
	for i in queue.size():
		var target = start_queue.global_position + (Vector2.LEFT * i * QUEUE_DISTANCE)
		queue[i].set_move_to_target(target)

func add_to_queue(customer: Customer):
	queue.push_back(customer)
	update_queue()

func finish_queue_front():
	queue.pop_front()
	update_queue()

func remove_from_queue(customer: Customer):
	queue.erase(customer)
	update_queue()

func earn_money(value: int):
	GameSystem.instance.earn_money(value)
	label.text = str(value) + " B"
	anim_player.play("earn_money")

func _on_body_entered(body: Node):
	if body is Player:
		visible_ui(true)
		var food = body.get_dish() as FoodDish
		if food and not queue.is_empty():
			var customer = queue.front()
			customer.pay_food(food.food_data)
			earn_money(food.food_data.value)
			body.destroy_dish()
			finish_queue_front()

func _on_body_exited(body: Node):
	if body is Player:
		visible_ui(false)

func visible_ui(value: bool):
	# Implement UI visibility logic here
	pass

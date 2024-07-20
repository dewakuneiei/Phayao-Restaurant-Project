extends Area2D
class_name Counter

const QUEUE_DISTANCE: int = 45

@onready var start_queue: Marker2D = $StartQeue
@onready var label: Label = $Label
@onready var anim_player: AnimationPlayer = $AnimationPlayer

var queue: Array[Customer] = []

func _ready():
	initialize()

func initialize():
	connect("body_entered", _on_body_entered)
	label.hide()

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
	GameManager.update_money(value)
	label.text = str(value) + " B"
	anim_player.play("earn_money")

func _on_body_entered(body: Node):
	if body is Player:
		var food = body.get_dish() as FoodDish
		if food and not queue.is_empty():
			var customer = queue.front()
			var foodData = food.food_data as FoodData
			customer.pay_food(foodData)
			earn_money(foodData.value)
			GameManager.update_log(foodData)
			body.destroy_dish()
			finish_queue_front()


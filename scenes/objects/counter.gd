extends Interactive
class_name Counter

const dist_of_queue: int = 45

@onready var start_mart: Marker2D = $StartQeue
@onready var label: Label = $Label
@onready var animplayer: AnimationPlayer = $AnimationPlayer

var our_queue = []

func interact(player: Player):
	var front_customer = our_queue.front() as Customer
	if front_customer == null: return;
	var food_name = front_customer.order_food.get_name()
	var reciption = Recipe.get_ingredient_ids_for_food(food_name)
	print(reciption)

func update_queue():
	var count = 0
	for customer in our_queue:
		if customer is Customer:
			var target = start_mart.global_position + (Vector2.LEFT * count * dist_of_queue)
			customer.set_move_to_target(target)
			count += 1

func add_to_queue(customer: Customer):
	our_queue.push_back(customer)
	update_queue()

func finish_queue_front():
	our_queue.pop_front()
	update_queue()

func remove_me_at(customer: Customer):
	var index = our_queue.find(customer)
	if index != -1:  # If the customer is found in the queue
		our_queue.remove_at(index)
		update_queue()

func earn_money_play(value: int):
	GameSystem.instance.earn_money(value)
	label.text = str(value)+ " B"
	animplayer.play("earn_money")

func _ready():
	label.hide()
	self.connect("body_entered", _on_send_order_body_entered)

func _on_send_order_body_entered(body):
	if body is Player:
		var food = body.get_dish() as FoodDish
		if food:
			var customer = our_queue.front() as Customer
			if customer:
				var foodData = food.food_data
				customer.pay_food(foodData)
				earn_money_play(foodData.value)
				body.destroy_dish()
				finish_queue_front()


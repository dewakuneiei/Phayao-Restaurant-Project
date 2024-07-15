extends Node2D
class_name Spawner

@export var customer_spawn_mark: Marker2D 

@onready var template: PackedScene = preload("res://scenes/characters/customer.tscn")

var spawn_timer: Timer
var cooldown_timer: Timer
var customers_to_spawn: int = 0

func _ready():
	set_process(false)
	set_process_input(false)
	set_physics_process(false)
	_initialize()

func _initialize():
	spawn_timer = Timer.new()
	spawn_timer.one_shot = true
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	add_child(spawn_timer)
	
	cooldown_timer = Timer.new()
	cooldown_timer.one_shot = true
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)
	add_child(cooldown_timer)
	
	GameManager.game_state_changed.connect(_on_game_state_changed)

func start_spawner():
	if get_tree().get_nodes_in_group("customer").size() > 5:
		cooldown_timer.start(_random_cool_down_time())
		return
	
	customers_to_spawn = GameManager.calculate_customer_amount()
	spawn_next_customer()

func spawn_next_customer():
	if customers_to_spawn <= 0:
		print("All customers spawned. Starting cooldown.")
		cooldown_timer.start(_random_cool_down_time())
		return

	var customer = template.instantiate()
	add_child(customer)
	customer.global_position = _get_random_spawn_point()
	
	customers_to_spawn -= 1
	
	if customers_to_spawn > 0:
		spawn_timer.start(randf_range(3, 6))
	else:
		cooldown_timer.start(_random_cool_down_time())

func _random_cool_down_time() -> float:
	return randf_range(10, 12) * GameManager.calculate_customer_amount()

func _on_spawn_timer_timeout():
	spawn_next_customer()

func _on_cooldown_timer_timeout():
	start_spawner()

func _get_random_spawn_point() -> Vector2:
	var random_offset = Vector2(randf_range(-10, 1), randf_range(-5, 5))
	return customer_spawn_mark.global_position + random_offset

func _on_game_state_changed(new_state):
	if new_state == GameManager.GameState.ENDED:
		process_mode = Node.PROCESS_MODE_DISABLED

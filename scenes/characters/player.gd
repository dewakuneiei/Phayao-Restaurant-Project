extends CharacterBody2D
class_name Player

static var instance: Player

# Player attributes
@export var _moveSpeed: float = 200.0
@onready var _rayCast: RayCast2D = $RayCast2D

var is_preparing_dish: bool = false

# Input map
var input_map: Dictionary = {
	"move_right": Vector2.RIGHT,
	"move_left": Vector2.LEFT,
	"move_down": Vector2.DOWN,
	"move_up": Vector2.UP
}

func _ready():
	instance = self
	set_process(true)

func _process(delta: float):
	handle_movement()
	if Input.is_action_just_pressed("interact"):
		interact_with_object()

func handle_movement():
	var direction = Vector2.ZERO
	for action in input_map.keys():
		if Input.is_action_pressed(action):
			direction += input_map[action]
	direction = direction.normalized()
	velocity = direction * _moveSpeed
	move_and_slide()
	update__rayCast_target(direction)

func update__rayCast_target(direction: Vector2):
	if direction != Vector2.ZERO:
		_rayCast.target_position = direction * 50

func interact_with_object():
	var object = get_interactable_object()
	if object:
		if object is Interactive and object.has_method("interact"):
			object.interact(self)
			

func get_interactable_object() -> Interactive:
	var get_collider : Interactive = _rayCast.get_collider()
	if get_collider:
		return get_collider
	return null

func complete_preparing_dish():
	if is_preparing_dish:
		is_preparing_dish = false
		# Logic to move the prepared dish to a cooking table
		transfer_dish_to_cooking_table()

func transfer_dish_to_cooking_table():
	# Logic to transfer the dish to a specific cooking table
	pass


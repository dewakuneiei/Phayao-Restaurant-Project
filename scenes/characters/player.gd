extends CharacterBody2D
class_name Player

static var instance: Player

# Player attributes
@export var _moveSpeed: float = 200.0
@onready var _rayCast: RayCast2D = $RayCast2D
@onready var _sprite: Sprite2D = $Sprite2D
@onready var _hand_mark: Marker2D = $Marker2D

var _hold_dish: Dish = null

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
	update_rayCast_target(direction)
	handle_sprite_dir(direction)

func handle_sprite_dir(dir: Vector2):
	if dir.x < 0 and _sprite.flip_h == false:
		_sprite.flip_h = true
		_turn_around()
	elif dir.x > 0 and _sprite.flip_h == true:
		_sprite.flip_h = false
		_turn_around()

func _turn_around():
		var temp = _hand_mark.position
		temp.x *= -1
		_hand_mark.position = temp

func update_rayCast_target(direction: Vector2):
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

func transfer_dish() -> Dish:
	var clone = _hold_dish.duplicate()
	_hold_dish.queue_free()
	_hold_dish = null
	return clone

func destroy_dish():
	if _hold_dish is Dish:
		_hold_dish.queue_free()

func take_item(dish: Dish):
	if is_holding_dish() or dish == null or not dish.is_in_group("dish"): 
		return
		
	_hold_dish = dish
	_hand_mark.add_child(_hold_dish)

func is_holding_dish() -> bool:
	return _hold_dish != null

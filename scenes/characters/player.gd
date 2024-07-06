extends CharacterBody2D
class_name Player

static var instance: Player

# Player attributes
@export_category("Refferences")
@export var _parent_scene: Node2D;
@export_category("Settings")
@export var _dist_drop: int = 35
@export var _dist_target: int = 30
@export var _moveSpeed: float = 200.0

@onready var _rayCast: RayCast2D = $RayCast2D
@onready var _sprite: Sprite2D = $Sprite2D
@onready var _hand_mark: Marker2D = $Marker2D

# Input map
var input_map: Dictionary = {
	"move_right": Vector2.RIGHT,
	"move_left": Vector2.LEFT,
	"move_down": Vector2.DOWN,
	"move_up": Vector2.UP
}
var can_move: bool = true

var _hold_dish: Dish = null

func _ready():
	instance = self
	set_process(true)
	set_process_input(false)

func _process(delta: float):
	handle_movement()
	if Input.is_action_just_pressed("interact"):
		interact_with_object()
	
	if Input.is_action_just_pressed("open_recipes"):
		toggle_recipes()

func handle_movement():
	if not can_move:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var direction = Vector2.ZERO
	for action in input_map.keys():
		if Input.is_action_pressed(action):
			direction += input_map[action]
	direction = direction.normalized()
	velocity = direction * _moveSpeed
	move_and_slide()
	update_rayCast_target(direction)
	handle_sprite_dir(direction)

func set_player_movement(movable: bool):
	can_move = movable
	set_process(can_move)
	if not can_move:
		velocity = Vector2.ZERO

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
		_rayCast.target_position = (direction.normalized() * _dist_target)

func interact_with_object():
	var object = get_interactable_object()
	if object != null:
		if object is Interactive and object.has_method("interact"):
			object.interact(self)
			return
			
	drop_item()

func get_interactable_object() -> Interactive:
	var get_collider : Interactive = _rayCast.get_collider()
	if get_collider:
		return get_collider
	return null

func drop_item():
	if _hold_dish == null: return
	_hand_mark.remove_child(_hold_dish)
	_parent_scene.add_child(_hold_dish)
	_hold_dish.global_position = _hand_mark.global_position + Vector2.DOWN * _dist_drop
	_hold_dish.set_collistion(true)
	_hold_dish = null

func transfer_dish() -> Dish:
	var temp = _hold_dish
	_hand_mark.remove_child(_hold_dish)
	_hold_dish = null
	return temp

func destroy_dish():
	if is_holding_dish() and _hold_dish is Dish:
		_hold_dish.queue_free()
		_hold_dish = null

func take_item(dish: Dish):
	if is_holding_dish() or dish == null or not dish.is_in_group("dish"): 
		return
	var parent = dish.get_parent()
	if parent:
		parent.remove_child(dish)
	
	_hold_dish = dish
	_hold_dish.global_position = Vector2.ZERO
	_hand_mark.add_child(_hold_dish)
func get_dish() -> Dish:
	return _hold_dish

func is_holding_dish() -> bool:
	return _hold_dish != null


func toggle_recipes():
	GameSystem.instance.recipes.toggle()


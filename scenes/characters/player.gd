extends CharacterBody2D
class_name Player
static var instance: Player

const FRONT_FRAME = 0
const BACK_FRAME = 1
const SIDE_FRAME = 2
const DIST_DROP_SIDE = 35
const DIST_DROP = 60

# Player attributes
@export_category("Settings")
@export var _moveSpeed: float = 100
@export var _dist_mark_x: int = 30

@onready var interactive_area: Area2D = %InteractionArea
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
var _can_interact : bool = false

func _ready():
	_initialized()
	set_process(true)
	set_process_input(false)

func _initialized():
	instance = self

func _process(delta: float):
	handle_movement()
	if Input.is_action_just_pressed("interact"):
		interact_with_object()
	elif Input.is_action_just_pressed("recipe"):
		GameSystem.instance.toggle_recipe()

func handle_movement():
	if not can_move:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	var direction = Vector2.ZERO
	for action in input_map.keys():
		if Input.is_action_pressed(action):
			direction += input_map[action]
			handle_sprite_dir(direction)
	direction = direction.normalized()
	velocity = direction * _moveSpeed

	# Calculate the new position
	var new_position = global_position + velocity * get_physics_process_delta_time()

	# Check boundaries
	new_position.x = clamp(new_position.x, -977, 1200)
	new_position.y = clamp(new_position.y, -133, 728)

	# Set the new position
	global_position = new_position

	# Update velocity based on the actual movement
	velocity = (global_position - position) / get_physics_process_delta_time()

	move_and_slide()
	

func set_player_movement(movable: bool):
	can_move = movable
	set_process(can_move)
	if not can_move:
		velocity = Vector2.ZERO

func handle_sprite_dir(dir: Vector2):
	if dir.x != 0:
		if dir.x < 0 and _sprite.flip_h == false:
			_sprite.flip_h = true
			_turn_around()
			
		elif dir.x > 0 and _sprite.flip_h == true:
			_sprite.flip_h = false
			_turn_around()
		_sprite.frame = SIDE_FRAME
	elif dir.y > 0:
		_sprite.frame = FRONT_FRAME
	elif dir.y < 0:
		_sprite.frame = BACK_FRAME
	
	

func _turn_around():
		var temp = _hand_mark.position
		temp.x *= -1
		_hand_mark.position = temp


func interact_with_object():
	var object = get_interactable_object()
	if object != null:
		if object is Interactive and object.has_method("interact"):
			object.interact(self)
			return
			
	drop_item()

func get_interactable_object() -> Interactive:
	var overlappings = interactive_area.get_overlapping_areas()
	var nearest_interactive: Interactive = null
	var shortest_distance_squared = INF
	for body in overlappings:
		if body is Interactive:
			var distance_squared = interactive_area.global_position.distance_squared_to(body.global_position)
			if distance_squared < shortest_distance_squared:
				shortest_distance_squared = distance_squared
				nearest_interactive = body
	
	return nearest_interactive

func drop_item():
	if _hold_dish == null: return
	
	var dropped_dish = _hold_dish  # Store a reference to the dish
	_hand_mark.remove_child(dropped_dish)
	get_parent().add_child(dropped_dish)
	
	# Set the position before nullifying _hold_dish
	if _sprite.frame == FRONT_FRAME:
		dropped_dish.global_position = _hand_mark.global_position + Vector2(0, DIST_DROP)
	elif _sprite.frame == BACK_FRAME:
		dropped_dish.global_position = _hand_mark.global_position + Vector2(0, DIST_DROP / 2)
	elif _sprite.frame == SIDE_FRAME:
		var drop_pos : Vector2 = Vector2(-DIST_DROP_SIDE, DIST_DROP) if _sprite.flip_h else Vector2(DIST_DROP_SIDE, DIST_DROP)
		dropped_dish.global_position = _hand_mark.global_position + drop_pos
	
	dropped_dish.set_collistion(true)
	_hold_dish = null  # Now set _hold_dish to null after using it


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

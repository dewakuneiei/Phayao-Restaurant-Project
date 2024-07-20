extends Area2D
class_name Customer

enum CustomerState {NONE, REQUEST, WAITING, FINISHED}

const MAX_WAITING = 60
const FRONT = 3
const BACK = 4
const SIDE = 5

### ANimation name
const SHOW_FEEDBACK = "show_feedback"
const SHOW_ORDER = "show_order"
const INVISIBLE_ORDER = "invisible_order"

@export_category("settings")
@export var move_speed: float = 100.0  # pixels per second
@export var max_players = 3
@export var max_particle_systems = 3
@onready var _nuh_sound = preload("res://assets/sfx/nuuuh.mp3")
@onready var _streamPlayer: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var _label: Label = %feedbackValueLabel
@onready var _sprite: Sprite2D = $Sprite2D
@onready var _particle_template: CPUParticles2D = $CPUParticles2D
@onready var _agent: NavigationAgent2D = %Agent
@onready var _animation_ply: AnimationPlayer = $AnimationPlayer
@onready var _food_texture: TextureRect = %FoodMenu


var order_food: FoodData
var is_mouse_enter: bool = false

var _gameSystem: GameSystem
var _counter: Counter
var _timer: float = 0
var _is_good = true
var _state: CustomerState = CustomerState.NONE
var _audio_players = []
var _next_player = 0
var _particle_systems = []
var _next_particle = 0
var _hit_count = 0

func _ready():
	set_process(true)
	set_physics_process(false)
	_create_pool_audio_stream()
	_timer = 0
	_is_good = true
	_sprite.frame = get_random_sprite_frame()

func _create_pool_audio_stream():
	# Create the pool of AudioStreamPlayer2D nodes
	for i in range(max_players):
		var player = AudioStreamPlayer2D.new()
		player.stream = _streamPlayer.stream
		player.bus = _streamPlayer.bus
		add_child(player)
		_audio_players.append(player)
	
	# Create the pool of CPUParticles2D nodes
	for j in range(max_particle_systems):
		var particles = _particle_template.duplicate() as CPUParticles2D
		particles.emitting = false
		add_child(particles)
		_particle_systems.append(particles)

func get_random_sprite_frame():
	var frame_options = [0, 3, 6, 9, 12, 15]
	var random_frame = frame_options[randi() % frame_options.size()]
	return FRONT + random_frame

func _physics_process(delta):
	if _agent.is_navigation_finished():
		set_physics_process(false)
		_on_movement_completed()
		return

	var next_path_position = _agent.get_next_path_position()
	var direction = global_position.direction_to(next_path_position)
	var velocity = direction * move_speed

	global_position += velocity * delta

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
			set_process(false)
	elif _state == CustomerState.FINISHED:
		set_process(false)

func _input(event):
	# Check if the event is a left mouse button press
	if not is_mouse_enter: return;
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		hit()

func set_move_to_target(target: Vector2):
	_agent.set_target_position(target)
	set_physics_process(true)

func _on_movement_completed():
	if order_food and _state == CustomerState.REQUEST:
		_state = CustomerState.WAITING

func sent_order_request():
	_gameSystem = GameSystem.instance
	if _gameSystem:
		_counter = _gameSystem.counter
	
	order_food = _gameSystem.get_random_food_menu() as FoodData
	_state = CustomerState.REQUEST
	_counter.add_to_queue(self)
	_food_texture.texture = order_food.icon

func pay_food(foodData: FoodData):
	_state = CustomerState.FINISHED
	set_move_to_target(_gameSystem.endPoint.global_position)
	feed_back(order_food == foodData)
	
	if is_mouse_enter:
		_animation_ply.play(INVISIBLE_ORDER)

func feed_back(is_it_right_food: bool):
	# right food and less wating
	if is_it_right_food and _is_good:
		GameManager.increase_rating()
		show_feedback(1)
	#not right food and less wating
	elif not is_it_right_food and _is_good:
		show_feedback(-1)
		GameManager.decrease_rating()
	elif not is_it_right_food and not _is_good:
		show_feedback(-1)
		GameManager.decrease_rating()

func is_none_state() -> bool:
	return _state == CustomerState.NONE

func _on_mouse_entered():
	is_mouse_enter = true
	
	if _state == CustomerState.WAITING:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
		_animation_ply.play(SHOW_ORDER)

func _on_mouse_exited():
	is_mouse_enter = false
	
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	if _state == CustomerState.WAITING:
		_animation_ply.play(INVISIBLE_ORDER)

func is_waiting():
	return _state == CustomerState.WAITING

func hit():
	if _state != CustomerState.WAITING: return;
	_hit_count += 1
	if _hit_count >= 3:
		leve()
	
	emit_particles()
	play_sound()

func emit_particles():
	var particles = _particle_systems[_next_particle]
	if not particles.emitting:
		particles.global_position = get_global_mouse_position()
		particles.restart()
		_next_particle = (_next_particle + 1) % max_particle_systems

func play_sound():
	var player = _audio_players[_next_player]
	if not player.playing:
		player.play()
		_next_player = (_next_player + 1) % max_players

func leve():
	_state = CustomerState.FINISHED
	_streamPlayer.stream = _nuh_sound
	_streamPlayer.play()
	GameManager.decrease_rating()
	_counter.remove_from_queue(self)
	set_move_to_target(GameSystem.instance.endPoint.position)
	
	if is_mouse_enter:
		_animation_ply.play("RESET")
	
	show_feedback(-1)

func show_feedback(value: int):
	if value > 0:
		_label.text = "+" + str(value)
	else:
		_label.text = str(value)
	
	_animation_ply.stop()
	_animation_ply.play(SHOW_FEEDBACK)

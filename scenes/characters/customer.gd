extends Area2D
class_name Customer

enum CustomerState {NONE, REQUEST, WAITING, FINISHED}
enum Feedback {GREAT, GOOD, BAD, ANGRY, ANNOYING}
enum State {IDLE, WALK}

const MAX_WAITING = 63

const ANIMATION = {
	SHOW_ORDER = "show_order",
	INVISIBLE_ORDER = "invisible_order",
	SHOW_GOOD_FEEDBACK = "show_good",
	SHOW_GREAT_FEEDBACK = "show_great",
	SHOW_BAD_FEEDBACK = "show_bad",
	SHOW_ANGRY = "show_angry",
	SHOW_ANNOYING = "show_annoying"
}

@export_category("settings")
@export var move_speed: float = 100.0  # pixels per second
@export var max_particle_systems = 3
@onready var _nuh_sound = preload("res://assets/sfx/nuuuh.mp3")
@onready var _slap_sound = preload("res://assets/sfx/slap.mp3")
@onready var _pop_sound = preload("res://assets/sfx/pop.wav")
@onready var _label: Label = %feedbackValueLabel
@onready var _sprite: Sprite2D = $Sprite2D
@onready var _particle_template: CPUParticles2D = $CPUParticles2D
@onready var _agent: NavigationAgent2D = %Agent
@onready var _animation_ply: AnimationPlayer = $AnimationPlayer
@onready var _food_texture: TextureRect = %FoodMenu

var frame_side = {
	front = 3,
	back = 4,
	side = 5,
}
var order_food: FoodData
var is_mouse_enter: bool = false
var state: State = State.IDLE
var action_state: CustomerState = CustomerState.NONE
var gameSystem: GameSystem
var counter: Counter

var _timer: float = 0
var _is_good = true
var _audio_players = []
var _next_player = 0
var _particle_systems = []
var _next_particle = 0
var _hit_count = 0
var _counter_player: Player

func _ready():
	set_process(true)
	set_physics_process(false)
	_create_pool()
	_timer = 0
	_is_good = true
	_sprite.frame = random_sprite_frame()
	
	await get_tree().create_timer(.5).timeout
	
	gameSystem = GameManager.gameSystem
	counter = gameSystem.counter
	counter.player_entered.connect(func(p: Player): _counter_player = p)
	counter.player_exited.connect(func(p: Player): _counter_player = p)

func _create_pool():
	# Create the pool of CPUParticles2D nodes
	for j in range(max_particle_systems):
		var particles = _particle_template.duplicate() as CPUParticles2D
		particles.emitting = false
		add_child(particles)
		_particle_systems.append(particles)

func random_sprite_frame():
	var frame_options = [0, 3, 6, 9, 12, 15]
	var random_frame = frame_options[randi() % frame_options.size()]
	frame_side.front += random_frame
	frame_side.back += random_frame
	frame_side.side += random_frame
	return frame_side.front 

func _physics_process(delta):
	if _agent.is_navigation_finished():
		state = State.IDLE
		_sprite.frame = frame_side.front
		set_physics_process(false)
		_on_movement_completed()
		return

	var next_path_position = _agent.get_next_path_position()
	var direction = global_position.direction_to(next_path_position)
	var velocity = direction * move_speed

	global_position += velocity * delta
	
	if state == State.IDLE and direction.x > 0:
		state = State.WALK
		_sprite.frame = frame_side.side

func _process(delta):
	if action_state == CustomerState.NONE:
		_timer += delta
		if _timer >= 3:
			_timer = 0
			sent_order_request()
	elif  action_state == CustomerState.WAITING:
		_timer += delta
		if _timer >= MAX_WAITING:
			_timer = 0
			_is_good = false
			show_feedback(Feedback.ANNOYING)
			set_process(false)
	elif action_state == CustomerState.FINISHED:
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
	if order_food and action_state == CustomerState.REQUEST:
		action_state = CustomerState.WAITING

func sent_order_request():
	order_food = gameSystem.get_random_food_menu() as FoodData
	action_state = CustomerState.REQUEST
	counter.add_to_queue(self)
	_food_texture.texture = order_food.icon

func pay_food(foodData: FoodData):
	action_state = CustomerState.FINISHED
	set_move_to_target(gameSystem.endPoint.global_position)
	feed_back(order_food == foodData)
	

func feed_back(is_it_right_food: bool):
	# right food and less wating
	if is_it_right_food and _is_good:
		GameManager.increase_rating2()
		show_feedback(Feedback.GREAT)
	elif is_it_right_food and not _is_good:
		GameManager.increase_rating()
		show_feedback(Feedback.GOOD)
	#not right food and less wating
	elif not is_it_right_food and _is_good:
		GameManager.decrease_rating()
		show_feedback(Feedback.BAD)
	elif not is_it_right_food and not _is_good:
		show_feedback(Feedback.ANGRY)
		GameManager.decrease_rating2()

#func is_noneaction_state() -> bool:
	#return action_state == CustomerState.NONE

func _on_mouse_entered():
	is_mouse_enter = true
	
	if action_state == CustomerState.WAITING:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
		_animation_ply.play(ANIMATION.SHOW_ORDER)

func _on_mouse_exited():
	is_mouse_enter = false
	
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	if action_state == CustomerState.WAITING:
		_animation_ply.play(ANIMATION.INVISIBLE_ORDER)

func is_waiting():
	return action_state == CustomerState.WAITING

func hit():
	if action_state != CustomerState.WAITING: return;
	
	if _counter_player and _counter_player.get_dish() is FoodDish:
		counter.process_order(_counter_player, self)
	else:
		_hit_count += 1
		if _hit_count >= 3:
			leve()
	
	emit_particles()
	play_sound2d(_slap_sound)

func emit_particles():
	var particles = _particle_systems[_next_particle]
	if not particles.emitting:
		particles.global_position = get_global_mouse_position()
		particles.restart()
		_next_particle = (_next_particle + 1) % max_particle_systems

func leve():
	action_state = CustomerState.FINISHED
	play_sound2d(_nuh_sound)
	GameManager.decrease_rating2()
	counter.remove_from_queue(self)
	set_move_to_target(GameSystem.instance.endPoint.position)
	
	if is_mouse_enter:
		_animation_ply.play("RESET")
	
	show_feedback(Feedback.ANGRY)

func play_sound2d(stream: AudioStream):
	var player = AudioStreamPlayer2D.new()
	player.bus = "SFX"
	player.stream = stream
	player.finished.connect(player.queue_free)
	add_child(player)
	player.play()

func show_feedback(feedback: Feedback):
	_animation_ply.stop()
	match (feedback):
		Feedback.GOOD:
			_animation_ply.play(ANIMATION.SHOW_GOOD_FEEDBACK)
		Feedback.GREAT:
			_animation_ply.play(ANIMATION.SHOW_GREAT_FEEDBACK)
		Feedback.BAD:
			_animation_ply.play(ANIMATION.SHOW_BAD_FEEDBACK)
		Feedback.ANGRY:
			_animation_ply.play(ANIMATION.SHOW_ANGRY)
		Feedback.ANNOYING:
			_animation_ply.play(ANIMATION.SHOW_ANNOYING)
	
	play_sound2d(_pop_sound)
	

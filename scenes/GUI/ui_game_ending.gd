extends Control
class_name GameEndUi

# Animation constants
const ANIMATION_TIME_FROM = 0.5
const ANIMATION_TIME_TO = 0.3

# Node references
@onready var container = %ItemContainer
@onready var log_template_item = preload("res://scenes/GUI/ui_log_item.tscn")
@onready var money_label: Label = %Money
@onready var result_label: Label = %Result
@onready var button_container = %ButtonContainer

func _ready():
	# Disable unnecessary processing
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	
	# Initial UI setup
	hide()
	result_label.hide()
	button_container.hide()
	
	# Connect signals
	container.child_entered_tree.connect(_on_child_entered_tree)

func show_me():
	process_mode = Node.PROCESS_MODE_ALWAYS
	GameManager.pause_game()
	show()
	
	await _animate_money_counter()
	await _show_result()
	await _display_game_log()
	
	button_container.show()

func _animate_money_counter():
	var money = GameManager.money
	var stream_player = _create_audio_player()
	
	# Play slot machine sound
	stream_player.stream = load("res://assets/sfx/slot-machine-41-sfx-producer.mp3")
	stream_player.play()
	
	# Animate money counter and font color
	var tween = create_tween()
	tween.set_parallel(true)  # Allow multiple tweens to run in parallel
	
	# Tween the money value
	tween.tween_method(func(value): 
		money_label.text = "%d %s" % [value, tr("BAHT")], 
		0, money, 2.1
	)
	
	# Rainbow color sequence
	var colors = [
		Color.RED,
		Color.ORANGE,
		Color.YELLOW,
		Color.GREEN,
		Color.BLUE,
		Color.INDIGO,
		Color.VIOLET,
		Color.WHITE  # End with white
	]
	
	# Tween through rainbow colors
	tween.tween_method(func(t):
		var index = int(t * (len(colors) - 1))
		var color1 = colors[index]
		var color2 = colors[min(index + 1, len(colors) - 1)]
		var blend = fmod(t * (len(colors) - 1), 1.0)
		var final_color = color1.lerp(color2, blend)
		money_label.add_theme_color_override("font_color", final_color),
		0.0, 1.0, 2.1
	)
	
	await tween.finished
	
	# Play cash register sound
	stream_player.stream = load("res://assets/sfx/cash-register-purchase.wav")
	stream_player.play()
	
	await get_tree().create_timer(1.0).timeout
	stream_player.queue_free()

func _show_result():
	result_label.show()
	var is_successful = GameManager.money >= GameManager.GOAL_MONEY
	result_label.text = tr("SUCCESS") if is_successful else tr("FAIL")
	
	# Use theme color override instead of modulate
	var color = Color.GOLD if is_successful else Color.GRAY
	result_label.add_theme_color_override("font_color", color)

func _display_game_log():
	var game_log = GameManager.game_log
	var z_index = 0
	
	for key in game_log.keys():
		var log_item = _create_log_item(key, game_log[key], z_index)
		z_index += 1
		await get_tree().create_timer(ANIMATION_TIME_FROM + ANIMATION_TIME_TO).timeout

func _create_audio_player() -> AudioStreamPlayer:
	var player = AudioStreamPlayer.new()
	player.bus = "SFX"
	add_child(player)
	return player

func _create_log_item(key, amount: int, z_index: int) -> LogItemUI:
	var log_item = log_template_item.instantiate() as LogItemUI
	container.add_child(log_item, true, Node.INTERNAL_MODE_FRONT)
	
	log_item.rect.texture = key.icon
	log_item.labelName.text = key.get_name()
	log_item.labelValue.text = "x" + str(amount)
	log_item.z_index = z_index
	
	container.move_child(log_item, 0)
	return log_item

func _on_child_entered_tree(node):
	if node is Control:
		animate_new_child(node)
		GameManager.play_sfx_with_stream(GameManager.stream_sfx_21)

func animate_new_child(node):
	node.scale = Vector2.ZERO
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	tween.tween_property(node, "scale", Vector2(2.1, 2.1), ANIMATION_TIME_FROM)
	tween.tween_property(node, "scale", Vector2.ONE, ANIMATION_TIME_TO)

func _on_again_pressed():
	GameManager.play_sfx()
	GameManager.load_game_scene()

func _on_home_pressed():
	GameManager.play_sfx()
	GameManager.load_main_scene()

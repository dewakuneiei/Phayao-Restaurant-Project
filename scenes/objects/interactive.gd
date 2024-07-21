extends CollisionObject2D
class_name Interactive

@export var interact_name: StringName;

func interact(player: Player):
	print("Player interact with "+ interact_name)
	pass

func play_sound(stream: AudioStream):
	var streamPlayer = AudioStreamPlayer2D.new()
	streamPlayer.stream = stream
	streamPlayer.bus = "SFX"
	streamPlayer.finished.connect(_reamove_node.bind(streamPlayer))
	add_child(streamPlayer)
	streamPlayer.play()

func _reamove_node(node: Node):
	node.queue_free()

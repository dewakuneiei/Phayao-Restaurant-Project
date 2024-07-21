extends Interactive
@onready var stream = preload("res://assets/sfx/freezer-door.mp3")
func interact(player: Player):
	player.destroy_dish()
	play_sound(stream)

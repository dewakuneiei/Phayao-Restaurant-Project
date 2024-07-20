extends Control
class_name GameEndUi

@onready var ui_template = preload("res://scenes/GUI/ui_log_item.tscn") 
@onready var container = %ItemContainer

func _ready():
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	hide()

func show_me(log: Dictionary):
	process_mode = Node.PROCESS_MODE_ALWAYS
	GameManager.pause_game()
	show()
	for key in log.keys():
		var data = log[key][0] as FoodData
		var amount = log[key][1] as int
		
		var new_entry = ui_template.instantiate()
		var textureRect = new_entry.get_child(0) as TextureRect
		var label = new_entry.get_child(1) as Label
		
		label.text = data.get_name() + " x" + str(amount)
		textureRect.texture = data.icon
		
		container.add_child(new_entry)
		

func _on_play_again_pressed():
	GameManager.load_game_scene()


func _on_main_pressed():
	GameManager.load_main_scene()

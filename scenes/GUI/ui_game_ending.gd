extends Control
class_name GameEndUi

func _ready():
	set_process(false)
	set_physics_process(false)
	set_process_input(false)

func update_ui():
	var score = GameManager.calculate_score()
	match (score):
		3:
			%scoreA.show()
			%scoreB.show()
			%scoreC.show()
			
		2:
			%scoreA.show()
			%scoreB.show()
			
		1:
			%scoreA.show()
	%Revenuel.text = str(GameManager.revenue) + " B"
	%Cost.text = str(GameManager.cost) + " B"
	%Profit.text = str(GameManager.get_profit()) + " B"


func _on_play_again_pressed():
	GameManager.load_game_scene()


func _on_main_pressed():
	GameManager.load_main_scene()

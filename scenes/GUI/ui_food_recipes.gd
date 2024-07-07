extends Control
class_name FoodRecipes

func _ready():
	set_process(false)
	set_process_input(false)
	set_physics_process(false)
	self.hide()  # Start hidden
	%FoodMenusRichLabel.text = get_translated_menu()
	GameManager.game_state_changed.connect(_on_game_state_changed)

func get_translated_menu():
	var menu_template : String = """
[center][b][font=res://assets/fonts/your_font.tres][color=#FFD700]{food_recipes}[/color][/font][/b][/center]
[color=#FF4500][b]{lon_pla_som}[/b][/color] [color=#4CAF50]-> {fry}[/color]
[indent]• {fish}
- {pork}
- {salt}
- {chili}[/indent]
[color=#FF4500][b]{chicken_khao_soi}[/b][/color] [color=#4CAF50]-> {boil}[/color]
[indent]• {chicken}
- {rice_noodle}
- {lime}
- {cilantro}[/indent]
[color=#FF4500][b]{khai_pam}[/b][/color] [color=#4CAF50]-> {grill}[/color]
[indent]• {chicken_egg} [color=#FFA500]x2[/color]
- {chili}
- {salt}[/indent]
[color=#FF4500][b]{ong_pu_na}[/b][/color] [color=#4CAF50]-> {grill}[/color]
[indent]• {field_crab} [color=#FFA500]x2[/color]
- {chicken_egg}
- {salt}[/indent]
[color=#FF4500][b]{aeb_pla_nil}[/b][/color] [color=#4CAF50]-> {grill}[/color]
[indent]• {fish}
- {chili}
- {salt}
- {cilantro}[/indent]
"""
	return menu_template.format({
		"food_recipes": tr("FOOD_RECIPES"),
		"lon_pla_som": tr("LON_PLA_SOM"),
		"fry": tr("FRY"),
		"fish": tr("FISH"),
		"pork": tr("PORK"),
		"salt": tr("SALT"),
		"chili": tr("CHILI"),
		"chicken_khao_soi": tr("CHICKEN_KHAO_SOI"),
		"boil": tr("BOIL"),
		"chicken": tr("CHICKEN"),
		"rice_noodle": tr("RICE_NOODLE"),
		"lime": tr("LIME"),
		"cilantro": tr("CILANTRO"),
		"khai_pam": tr("KHAI_PAM"),
		"grill": tr("GRILL"),
		"chicken_egg": tr("CHICKEN_EGG"),
		"ong_pu_na": tr("ONG_PU_NA"),
		"field_crab": tr("FIELD_CRAB"),
		"aeb_pla_nil": tr("AEB_PLA_NIL")
	})

func toggle():
	visible = !visible  # Toggle visibility
	if visible:
		GameManager.pause_game()
	else:
		GameManager.resume_game()

func _unhandled_input(event):
	if event.is_action_pressed("open_recipes"):
		toggle()
	
func _on_game_state_changed(new_state):
	if new_state != GameManager.GameState.ENDED: return
	
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED


func _on_resume_pressed():
	GameManager.resume_game()
	visible = false


func _on_new_pressed():
	GameManager.load_game_scene()


func _on_main_pressed():
	GameManager.load_main_scene()

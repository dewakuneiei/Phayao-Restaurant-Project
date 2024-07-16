extends PanelContainer
class_name RecipeUI

@onready var item_container: Container = %ItemContainer
const SCENE_PATH = "res://scenes/GUI/ui_%s_item.tscn"
var customer: Customer

func update_recipe(counter: Counter, arr: Array) -> void:
	var cur_customer = counter.queue.front() if not counter.queue.is_empty() else null
	if customer == cur_customer: 
		return
	remove_all_children()
	customer = cur_customer
	var food_recipes = Recipe.food_recipes as Dictionary
	for key in food_recipes.keys():
		var recipe = food_recipes[key] as Array
		if recipe == arr:
			add_recipe_item(str(key).to_lower())
			return
	print("Unknown recipe")

func add_recipe_item(recipe_name: String) -> void:
	var scene_path = SCENE_PATH % recipe_name
	var packed_scene = load(scene_path)
	if packed_scene:
		var instance = packed_scene.instantiate()
		item_container.add_child(instance)
	else:
		print("Failed to load scene: ", scene_path)

func show_specific_recipe(recipe_name: String) -> void:
	add_recipe_item(recipe_name.to_lower())

func remove_all_children():
	for child in item_container.get_children():
		item_container.remove_child(child)
		child.queue_free()

func _ready():
	set_process(false)
	set_process_input(false)
	set_process_unhandled_input(false)

func _on_button_pressed():
	hide()

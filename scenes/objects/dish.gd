extends Interactive
class_name Dish

func _ready():
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	set_collistion(false)
	
	
func set_collistion(enable: bool):
	$CollisionShape2D.disabled = not enable
	z_index = 1 if enable else 2

func interact(player: Player):
	if player.is_holding_dish(): return;
	player.take_item(self)
	set_collistion(false)

func set_sprite_texture(icon: Texture):
	$Sprite2D.texture = icon

func get_texuture() -> Texture:
	return $Sprite2D.texture

func clone_sprite() -> Sprite2D:
	return $Sprite2D.duplicate() as Sprite2D

extends Interactive
class_name Dish

var ingredient_id: int

func _ready():
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	set_collistion(false)
	
	
func set_collistion(enable: bool):
	$CollisionShape2D.disabled = not enable

func interact(player: Player):
	player.take_item(self)
	set_collistion(false)

func set_sprite_texture(texture: Texture):
	$Sprite2D.texture = texture

func get_texutre() -> Texture:
	return $Sprite2D.texture

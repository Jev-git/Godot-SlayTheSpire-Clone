extends Node2D
class_name Unit

var m_vTextureSize: Vector2

func _ready():
	var vTextureSize: Vector2 = $Sprite.get_texture().get_size()
	var vScale: Vector2 = $Sprite.get_scale()
	m_vTextureSize = Vector2(vTextureSize.x * vScale.x, vTextureSize.y * vScale.y)

func highlight():
	pass
	# Set bool to draw bound around the Unit using the draw_rect() func from inside _draw()

extends Node2D
class_name Unit

enum STATE {DEFAULT, HIGHLIGHTING, HOVERING}
onready var m_iState: int = STATE.DEFAULT
onready var m_bHighlightAllEnemies: bool = false
onready var m_nUnits: Node2D = get_tree().get_nodes_in_group("Units")[0]

export var m_iMaxHP: int = 70
onready var m_iCurrentHP: int
onready var m_nHPLabel = $HPLabel

var m_vTextureSize: Vector2

func _ready():
	var vTextureSize: Vector2 = $Sprite.get_texture().get_size()
	var vScale: Vector2 = $Sprite.get_scale()
	m_vTextureSize = Vector2(vTextureSize.x * vScale.x, vTextureSize.y * vScale.y)
	
	$TextureRect.connect("mouse_entered", self, "_on_mouse_entered")
	$TextureRect.connect("mouse_exited", self, "_on_mouse_exited")
	
	set_hp(m_iMaxHP)

func _process(delta):
	update()

func _draw():
	match m_iState:
		STATE.HIGHLIGHTING:
			draw_rect(Rect2(- m_vTextureSize * 0.6, m_vTextureSize * 1.2), Color.green, false)
		STATE.HOVERING:
			draw_rect(Rect2(- m_vTextureSize * 0.6, m_vTextureSize * 1.2), Color.yellow, false)

func set_highlight(_bIsHighlighting: bool, _bHighlightAllEnemies: bool = false):
	m_bHighlightAllEnemies = _bHighlightAllEnemies
	match m_iState:
		STATE.DEFAULT:
			if _bIsHighlighting:
				m_iState = STATE.HIGHLIGHTING
		_:
			if !_bIsHighlighting:
				m_iState = STATE.DEFAULT

func _on_mouse_entered():
	if m_bHighlightAllEnemies:
		for nEnemy in m_nUnits.get_node("Enemies").get_children():
			if nEnemy.m_iState == STATE.HIGHLIGHTING:
				nEnemy.m_iState = STATE.HOVERING
	else:
		if m_iState == STATE.HIGHLIGHTING:
			m_iState = STATE.HOVERING

func _on_mouse_exited():
	if m_bHighlightAllEnemies:
		for nEnemy in m_nUnits.get_node("Enemies").get_children():
			if nEnemy.m_iState == STATE.HOVERING:
				nEnemy.m_iState = STATE.HIGHLIGHTING
	else:
		if m_iState == STATE.HOVERING:
			m_iState = STATE.HIGHLIGHTING

func set_hp(_iHP: int):
	m_iCurrentHP = _iHP
	if m_iCurrentHP <= 0:
		print_debug("DED!!1!")
		m_nHPLabel.text = ""
	else:
		m_nHPLabel.text = "%s/%s" % [m_iCurrentHP, m_iMaxHP]

func take_damage(_iDamage: int):
	set_hp(m_iCurrentHP - _iDamage)

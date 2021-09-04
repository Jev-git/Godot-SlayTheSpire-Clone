extends Node2D

enum TARGET_TYPE {PLAYER, ENEMY_SINGLE, ENEMY_ALL} # This will come from config file
onready var m_iTargetType = randi() % TARGET_TYPE.size()

enum STATE {DEFAULT, HOVERING, SELECTING}
onready var m_iState = STATE.DEFAULT
onready var m_bIsSelecting = false
onready var m_nUnits: Node2D = get_tree().get_nodes_in_group("Units")[0]
onready var m_iHoverOffset: int = 10
onready var m_vCardSize: Vector2 = $Sprite.get_texture().get_size()

func _ready():
	randomize()
	
	$TextureRect.connect("mouse_entered", self, "_on_mouse_entered")
	$TextureRect.connect("mouse_exited", self, "_on_mouse_exited")
	
func _draw():
	if m_bIsSelecting:
		draw_rect(Rect2(Vector2.ZERO, m_vCardSize), Color.green, false)

func _process(delta):
	update()

func _input(event):
	if event is InputEventMouse:
		if m_iState == STATE.HOVERING and event.is_pressed() and event.get_button_mask() == BUTTON_LEFT:
			_change_state(STATE.SELECTING)
		elif m_iState == STATE.SELECTING and event.is_pressed() and event.get_button_mask() == BUTTON_RIGHT:
			_change_state(STATE.DEFAULT)

func _on_mouse_entered():
	if m_iState == STATE.DEFAULT:
		_change_state(STATE.HOVERING)

func _on_mouse_exited():
	if m_iState == STATE.HOVERING:
		_change_state(STATE.DEFAULT)

func _highlight_possible_target(_bIsHighlighting: bool):
	if m_iTargetType == TARGET_TYPE.PLAYER:
		var nPlayer: Unit = m_nUnits.get_node("Player")
		nPlayer.set_highlight(_bIsHighlighting)
	else:
		var anEnemies = m_nUnits.get_node("Enemies").get_children()
		for nEnemy in anEnemies:
			nEnemy.set_highlight(_bIsHighlighting, m_iTargetType == TARGET_TYPE.ENEMY_ALL)

func _change_state(_iNewState: int):
	match m_iState:
		STATE.DEFAULT:
			if _iNewState == STATE.HOVERING: # Mouse over the card
				global_position.y -= m_iHoverOffset
				z_index = 10
		STATE.HOVERING:
			if _iNewState == STATE.DEFAULT: # Mouse exit the card
				global_position.y += m_iHoverOffset
				z_index = 0
			elif _iNewState == STATE.SELECTING: # Mouse over and select
				m_bIsSelecting = true
				_highlight_possible_target(true)
		STATE.SELECTING:
			if _iNewState == STATE.DEFAULT: # Deselect the card
				m_bIsSelecting = false
				z_index = 0
				_highlight_possible_target(false)
				global_position.y += m_iHoverOffset
	m_iState = _iNewState

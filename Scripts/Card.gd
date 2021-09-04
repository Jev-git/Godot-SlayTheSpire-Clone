extends Node2D

enum TARGET_TYPE {SELF, ENEMY_SINGLE, ENEMY_ALL, NONE} # This will come from config file
onready var m_iTargetType = randi() % TARGET_TYPE.size()

export var m_iHoverOffset: int = 10

enum STATE {DEFAULT, HOVERING, SELECTING}
onready var m_iState = STATE.DEFAULT
onready var m_bIsSelecting = false

func _ready():
	$TextureRect.connect("mouse_entered", self, "_on_mouse_entered")
	$TextureRect.connect("mouse_exited", self, "_on_mouse_exited")

func _draw():
	if m_bIsSelecting:
		draw_line(Vector2(32, 0), get_viewport().get_mouse_position() - global_position, Color.blue)

func _process(delta):
	update()

func _input(event):
	if event is InputEventMouse:
		if m_iState == STATE.HOVERING and event.is_pressed() and event.get_button_mask() == BUTTON_LEFT:
			m_iState = STATE.SELECTING
			m_bIsSelecting = true
		elif m_iState == STATE.SELECTING and event.is_pressed() and event.get_button_mask() == BUTTON_RIGHT:
			m_iState = STATE.DEFAULT
			m_bIsSelecting = false
			global_position.y += m_iHoverOffset

func _on_mouse_entered():
	if m_iState == STATE.DEFAULT:
		m_iState = STATE.HOVERING
		global_position.y -= m_iHoverOffset

func _on_mouse_exited():
	if m_iState == STATE.HOVERING:
		m_iState = STATE.DEFAULT
		global_position.y += m_iHoverOffset

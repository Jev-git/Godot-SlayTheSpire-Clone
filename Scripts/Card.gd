extends Node2D

enum TARGET_TYPE {SELF, ENEMY_SINGLE, ENEMY_ALL, NONE} # This will come from config file
onready var m_iTargetType = randi() % TARGET_TYPE.size()

export var m_iHoverOffset: int = 10

enum STATE {DEFAULT, HOVERING, SELECTING}
onready var m_iState = STATE.DEFAULT

func _ready():
	$TextureRect.connect("mouse_entered", self, "_on_mouse_entered")
	$TextureRect.connect("mouse_exited", self, "_on_mouse_exited")

func _input(event):
	if event is InputEventMouse and m_iState == STATE.HOVERING:
		if event.is_pressed():
			m_iState = STATE.SELECTING

func _on_mouse_entered():
	if m_iState == STATE.DEFAULT:
		m_iState = STATE.HOVERING
		global_position.y -= m_iHoverOffset

func _on_mouse_exited():
	if m_iState == STATE.HOVERING:
		m_iState = STATE.DEFAULT
		global_position.y += m_iHoverOffset

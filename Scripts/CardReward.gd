extends Node2D
class_name CardReward

onready var m_iID: int
var m_iCardType: int

enum STATE {DEFAULT, HOVERING, SELECTING}
onready var m_iState = STATE.DEFAULT
onready var m_iHoverOffset: int = 10
var m_vCardSize: Vector2

signal selected(_iID)

func init(_aCardData: Array):
	m_iID = int(_aCardData.pop_front())
	$TextureRect.texture = load("res://Assets/Cards/%s.webp" % _aCardData.pop_front())
	
	$TextureRect.connect("mouse_entered", self, "_on_mouse_entered")
	$TextureRect.connect("mouse_exited", self, "_on_mouse_exited")

func _input(event):
	if event is InputEventMouse:
		if m_iState == STATE.HOVERING and event.is_pressed() and event.get_button_mask() == BUTTON_LEFT:
			change_state(STATE.SELECTING)
		elif m_iState == STATE.SELECTING and event.is_pressed() and event.get_button_mask() == BUTTON_RIGHT:
			change_state(STATE.DEFAULT)

func _on_mouse_entered():
	if m_iState == STATE.DEFAULT:
		change_state(STATE.HOVERING)

func _on_mouse_exited():
	if m_iState == STATE.HOVERING:
		change_state(STATE.DEFAULT)

func change_state(_iNewState: int):
	match m_iState:
		STATE.DEFAULT:
			if _iNewState == STATE.HOVERING: # Mouse over the card
				global_position.y -= m_iHoverOffset
				z_index = 10
		STATE.HOVERING:
			if _iNewState == STATE.DEFAULT: # Mouse exit the card
				global_position.y += m_iHoverOffset
				z_index = 0
			elif _iNewState == STATE.SELECTING: # Select a card
				emit_signal("selected", m_iID)
	m_iState = _iNewState

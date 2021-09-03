extends Node2D

export var m_iHoverOffset: int = 10

func _ready():
	$TextureRect.connect("mouse_entered", self, "_on_mouse_entered")
	$TextureRect.connect("mouse_exited", self, "_on_mouse_exited")

func _on_mouse_entered():
	global_position.y -= m_iHoverOffset

func _on_mouse_exited():
	global_position.y += m_iHoverOffset

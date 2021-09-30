extends Node2D
class_name PlayerEnergy

export var m_iMaxEnergy: int = 3
var m_iCurrentEnergy: int
onready var m_nLabel: Label = $Label

func get_current_energy() -> int:
	return m_iCurrentEnergy

func use_energy(_iAmount: int):
	if m_iCurrentEnergy >= _iAmount:
		m_iCurrentEnergy -= _iAmount
		update_label()
	else:
		printerr("Energy required > energy has: %s > %s" % [_iAmount, m_iCurrentEnergy])

func update_label():
	m_nLabel.text = "Energy: %s/%s" % [m_iCurrentEnergy, m_iMaxEnergy]

func reset_turn():
	m_iCurrentEnergy = m_iMaxEnergy
	update_label()

extends Node2D
class_name Effect

export var m_fDmgAmp: float = 0.5
var m_iDuration: int

onready var m_nDurationLabel: Label = $DurationLabel

func get_class() -> String:
	return "VulnerableFX"

func init(_iDuration: int):
	m_iDuration = _iDuration
	if !m_nDurationLabel:
		yield(self, "ready")
	_update_duration_label()

func get_amped_dmg(iDmg: int) -> int:
	return int((1 + m_fDmgAmp) * iDmg)

func reduce_duration_by_one():
	m_iDuration -= 1
	if m_iDuration == 0:
		queue_free()
	else:
		_update_duration_label()

func increase_duration(_iDuration: int):
	m_iDuration += _iDuration
	_update_duration_label()

func _update_duration_label():
	m_nDurationLabel.text = String(m_iDuration)

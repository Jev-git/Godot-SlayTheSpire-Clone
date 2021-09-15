extends Node2D
class_name EffectWithDuration

var m_iType: int
var m_iDuration: int

onready var m_nDurationLabel: Label = $DurationLabel

func init(_iType: int, _iDuration: int):
	m_iType = _iType
	m_iDuration = _iDuration
	if !m_nDurationLabel:
		yield(self, "ready")
	_update_duration_label()

func get_effect_type() -> int:
	return m_iType

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

extends Node2D
class_name UnitEffect

var m_iType: int
var m_iStackCount: int
var m_bHasDuration: bool

onready var m_iStackCountLabel: Label = $Label
onready var m_fDisplayWidth: float = $Sprite.get_rect().size.x * 2

func init(_iStackCount: int):
	m_iStackCount = _iStackCount
	if !m_iStackCountLabel:
		yield(self, "ready")
	_update_stack_count_label()

func get_effect_type() -> int:
	return m_iType

func increase_stack_count(_iStackCount: int):
	m_iStackCount += _iStackCount
	_update_stack_count_label()

func _update_stack_count_label():
	m_iStackCountLabel.text = String(m_iStackCount)

func reduce_stack_count_by_one():
	m_iStackCount -= 1
	if m_iStackCount == 0:
		queue_free()
	else:
		_update_stack_count_label()

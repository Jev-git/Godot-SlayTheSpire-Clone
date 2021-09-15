extends Node2D
class_name Effects

export var m_psVulnerableFX: PackedScene
export var m_psWeakFX: PackedScene

enum EFFECT_TYPE {VULNERABLE, WEAK}
onready var EFFECT_SCENES = [m_psVulnerableFX, m_psWeakFX]

func apply_effect(_iEffectType: int, _iDuration: int):
	if _iDuration == 0:
		return
	
	for nEffect in get_children():
		if nEffect.get_effect_type() == _iEffectType:
			nEffect.increase_duration(_iDuration)
			return
	
	var nEffect: EffectWithDuration = EFFECT_SCENES[_iEffectType].instance()
	nEffect.init(_iEffectType, _iDuration)
	add_child(nEffect)

func reduce_effect_duration():
	for nEffect in get_children():
		nEffect.reduce_duration_by_one()

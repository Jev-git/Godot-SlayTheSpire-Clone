extends UnitEffect
class_name VulnerableFX

export var m_fDmgAmp: float = 0.5

func init(_iStackCount: int):
	.init(_iStackCount)
	m_iType = UnitEffectUtil.EFFECT_TYPES.VULNERABLE
	m_bHasDuration = true

func get_amped_dmg(_iDmg: int) -> int:
	return int((1 + m_fDmgAmp) * _iDmg)

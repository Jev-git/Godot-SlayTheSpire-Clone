extends UnitEffect
class_name WeakFX

export var m_fWeakMultiplier: float = 0.25

func init(_iStackCount: int):
	.init(_iStackCount)
	m_iType = UnitEffectUtil.EFFECT_TYPES.WEAK
	m_bHasDuration = true

func get_weaken_dmg(_iDmg: int) -> int:
	return int(_iDmg * (1 - m_fWeakMultiplier))

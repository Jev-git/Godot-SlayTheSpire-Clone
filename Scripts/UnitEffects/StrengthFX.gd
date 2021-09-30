extends UnitEffect
class_name StrengthFX

func init(_iStackCount: int):
	.init(_iStackCount)
	m_iType = UnitEffectUtil.EFFECT_TYPES.STRENGTH
	m_bHasDuration = false

func get_amped_dmg(_iDmg: int) -> int:
	return _iDmg + m_iStackCount

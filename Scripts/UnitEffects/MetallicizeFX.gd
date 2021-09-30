extends UnitEffect
class_name MetallicizeFX

func init(_iStackCount: int):
	.init(_iStackCount)
	m_iType = UnitEffectUtil.EFFECT_TYPES.METALLICIZE
	m_bHasDuration = false

extends EffectWithDuration

export var m_fWeakMultiplier: float = 0.25

func get_class() -> String:
	return "WeakFX"

func get_weaken_dmg(iDmg: int) -> int:
	return int(iDmg * (1 - m_fWeakMultiplier))

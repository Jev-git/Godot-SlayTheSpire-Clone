extends EffectWithDuration

export var m_fDmgAmp: float = 0.5

func get_class() -> String:
	return "VulnerableFX"

func get_amped_dmg(iDmg: int) -> int:
	return int((1 + m_fDmgAmp) * iDmg)

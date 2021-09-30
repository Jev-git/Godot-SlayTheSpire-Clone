extends Unit
class_name Player

func _ready():
	._ready()
	var iSavedHP = PersistantData.m_iPlayerHP
	if iSavedHP > 0:
		set_hp(PersistantData.m_iPlayerHP)

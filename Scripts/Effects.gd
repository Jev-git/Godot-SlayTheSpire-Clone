extends Node2D
class_name Effects

func apply_effect(_iEffectType: int, _iDuration: int):
	if _iDuration == 0:
		return

	for nEffect in get_children():
		if nEffect.get_effect_type() == _iEffectType:
			nEffect.increase_stack_count(_iDuration)
			return
	
	var nEffect: UnitEffect = load(UnitEffectUtil.get_effect_scene_name(_iEffectType)).instance()
	nEffect.init(_iDuration)
	add_child(nEffect)
	nEffect.connect("tree_exited", self, "_on_effect_expire")
	nEffect.position.x = nEffect.m_fDisplayWidth * (get_child_count() - 1)

func reduce_effect_duration():
	for nEffect in get_children():
		if nEffect.m_bHasDuration:
			nEffect.reduce_stack_count_by_one()

func _on_effect_expire():
	for i in range(get_child_count()):
		var nEffect = get_child(i)
		nEffect.position.x = nEffect.m_fDisplayWidth * i

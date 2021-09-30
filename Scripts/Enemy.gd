extends Unit
class_name Enemy

onready var m_nTurnManager: TurnManager = get_tree().get_nodes_in_group("TurnManager")[0]
export var m_iDamage: int = 7

signal end_turn

func start_turn():
	m_nAnimPlayer.play("Enemy Attack")
	yield(m_nAnimPlayer, "animation_finished")
	deal_damage(m_iDamage, m_nPlayer)
	yield(get_tree().create_timer(0.5), "timeout")
	var m_nNextEnemy: Enemy = get_next_enemy()
	if m_nNextEnemy:
		m_nNextEnemy.start_turn()
	else:
		emit_signal("end_turn")

func get_next_enemy() -> Enemy:
	var bFound: bool = false
	for nEnemy in m_nEnemies.get_children():
		if bFound: return nEnemy
		if nEnemy.get_name() == get_name():
			bFound = true
	return null

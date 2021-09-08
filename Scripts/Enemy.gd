extends Unit
class_name Enemy

onready var m_nTurnManager: TurnManager = get_tree().get_nodes_in_group("TurnManager")[0]
export var m_iDamage: int = 7

func start_turn():
	m_nPlayer.take_damage(m_iDamage)
	print_debug("%s deals %s damages to player" % [get_name(), m_iDamage])
	var m_nNextEnemy: Enemy = get_next_enemy()
	if m_nNextEnemy:
		m_nNextEnemy.start_turn()
	else:
		m_nTurnManager.end_enemies_turn()

func get_next_enemy() -> Enemy:
	var bFound: bool = false
	for nEnemy in m_nEnemies.get_children():
		if bFound: return nEnemy
		if nEnemy.get_name() == get_name():
			bFound = true
	return null

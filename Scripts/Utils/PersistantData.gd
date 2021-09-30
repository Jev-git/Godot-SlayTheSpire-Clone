extends Node

var m_iPlayerHP: int

func save_data():
	m_iPlayerHP = get_tree().get_nodes_in_group("Units")[0].get_node("Player").m_iCurrentHP

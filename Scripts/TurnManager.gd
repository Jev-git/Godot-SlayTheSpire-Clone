extends Node2D
class_name TurnManager

onready var m_nCards = get_tree().get_nodes_in_group("Cards")[0]
onready var m_nUnits = get_tree().get_nodes_in_group("Units")[0]
onready var m_nPlayer = m_nUnits.get_node("Player")
onready var m_nEnemies = m_nUnits.get_node("Enemies")

func _ready():
	start_player_turn()

func start_player_turn():
	print_debug("~")
	m_nPlayer.set_block(0)
	m_nCards.draw_cards()

func end_player_turn():
	print_debug("~")
	m_nCards.discard()
	m_nCards.set_selected_card(null)
	
	m_nPlayer.set_highlight(false)
	for nEnemy in m_nEnemies.get_children():
		nEnemy.set_highlight(false)
	
	start_enemies_turn()

func start_enemies_turn():
	print_debug("~")
	m_nEnemies.get_child(0).start_turn()

func end_enemies_turn():
	print_debug("~")
	start_player_turn()

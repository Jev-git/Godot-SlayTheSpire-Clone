extends Node2D
class_name TurnManager

onready var m_nCards = get_tree().get_nodes_in_group("Cards")[0]
onready var m_nUnits = get_tree().get_nodes_in_group("Units")[0]
onready var m_nPlayer: Unit = m_nUnits.get_node("Player")
onready var m_nEnemies: Node2D = m_nUnits.get_node("Enemies")
onready var m_nPlayerEnergy: PlayerEnergy = get_tree().get_nodes_in_group("Energy")[0]
onready var m_nEndTurnButton: Button = get_tree().get_nodes_in_group("EndTurnButton")[0]
onready var m_anUIButtons: Array = get_tree().get_nodes_in_group("UIButtons")

func _ready():
	for nEmemy in m_nEnemies.get_children():
		nEmemy.connect("end_turn", self, "_end_enemies_turn")
	m_nEndTurnButton.connect("pressed", self, "_end_player_turn")
	
	yield(m_nPlayerEnergy, "ready")
	_start_player_turn()

func _start_player_turn():
	m_nPlayer.set_block(0)
	m_nCards.draw_cards(5)
	m_nPlayerEnergy.reset_turn()

func _end_player_turn():
	m_nCards.discard_hand()
	m_nCards.set_selected_card(null)
	
	m_nPlayer.set_highlight(false)
	for nEnemy in m_nEnemies.get_children():
		nEnemy.set_highlight(false)
	
	for nUIButton in m_anUIButtons:
		nUIButton.visible = false
	
	_start_enemies_turn()

func _start_enemies_turn():
	m_nEnemies.get_child(0).start_turn()

func _end_enemies_turn():
	for nUIButton in m_anUIButtons:
		nUIButton.visible = true
	
	_start_player_turn()

extends Node2D

onready var m_nCardsInHand: Node2D = get_tree().get_nodes_in_group("Cards")[0]
onready var m_nUnits: Node2D = get_tree().get_nodes_in_group("Units")[0]
onready var m_nPlayer: Unit = m_nUnits.get_node("Player")
onready var m_nEnemies: Node2D = m_nUnits.get_node("Enemies")

func _ready():
	$Button.connect("pressed", self, "_on_button_pressed")

func _on_button_pressed():
	m_nCardsInHand.discard()
	m_nCardsInHand.set_selected_card(null)
	
	m_nPlayer.set_highlight(false)
	m_nPlayer.set_block(0)
	
	for nEnemy in m_nEnemies.get_children():
		nEnemy.set_highlight(false)

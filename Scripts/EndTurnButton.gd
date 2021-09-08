extends Node2D

onready var m_nTurnManager: Node2D = get_tree().get_nodes_in_group("TurnManager")[0]

func _ready():
	$Button.connect("pressed", self, "_on_button_pressed")

func _on_button_pressed():
	m_nTurnManager.end_player_turn()

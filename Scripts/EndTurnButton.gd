extends Node2D

onready var m_nCardsInHand: Node2D = get_parent().get_node("CardsInHand")

func _ready():
	$Button.connect("pressed", self, "_on_button_pressed")

func _on_button_pressed():
	m_nCardsInHand.discard()

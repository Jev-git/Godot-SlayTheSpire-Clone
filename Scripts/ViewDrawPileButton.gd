extends Button

onready var m_nCardsInHand = get_tree().get_nodes_in_group("Cards")[0]

func _ready():
	connect("pressed", self, "_on_pressed")

func _on_pressed():
	print(m_nCardsInHand.m_aiDrawPile)

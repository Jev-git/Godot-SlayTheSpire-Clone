extends Button

onready var m_nCardsInHand = get_tree().get_nodes_in_group("Cards")[0]

func _ready():
	connect("pressed", self, "_on_pressed")

func _on_pressed():
	var asCardNames = []
	for iCardID in m_nCardsInHand.m_aiDrawPile:
		asCardNames.append(CardUtil.get_card_data_with_id(iCardID)[1])
	print(asCardNames)

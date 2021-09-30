extends Node2D

export var m_psCard: PackedScene
var m_aiDrawPile: Array
onready var m_aiDiscardPile = []
var m_oSelectedCard: Card

onready var m_nUnits: Node2D = get_tree().get_nodes_in_group("Units")[0]
onready var m_nPlayer: Unit = m_nUnits.get_node("Player")
onready var m_nEnemies: Node2D = m_nUnits.get_node("Enemies")

func init():
	m_aiDrawPile = CardUtil.get_deck()
	m_aiDrawPile.shuffle()
	m_nPlayer.connect("selected", self, "_on_unit_selected")
	for nEnemy in m_nEnemies.get_children():
		nEnemy.connect("selected", self, "_on_unit_selected")

func draw_cards(_iAmount: int):
	var iCardsToDraw: int = _iAmount
	var iExtraCardsToDraw: int = 0
	
	if _iAmount > m_aiDrawPile.size():
		iCardsToDraw = m_aiDrawPile.size()
		iExtraCardsToDraw = _iAmount - m_aiDrawPile.size()
		
	for i in range(get_child_count(), get_child_count() + iCardsToDraw):
		var nCard: Card = m_psCard.instance()
		nCard.init(CardUtil.get_card_data_with_id(m_aiDrawPile.pop_front()))
		nCard.connect("selected", self, "set_selected_card")
		nCard.connect("discard", self, "_discard_card")
		add_child(nCard)
		nCard.position.x = i * nCard.m_vCardSize.x * 0.6
	
	if iExtraCardsToDraw > 0:
		move_discard_pile_to_draw_pile()
		draw_cards(iExtraCardsToDraw)

func _discard_card(_iID: int):
	m_aiDiscardPile.append(_iID)

func discard_hand():
	for nCard in get_children():
		m_aiDiscardPile.append(nCard.m_iID)
		nCard.queue_free()

func move_discard_pile_to_draw_pile():
	m_aiDrawPile.append_array(m_aiDiscardPile)
	m_aiDiscardPile = []
	m_aiDrawPile.shuffle()

func set_selected_card(_oCard: Card):
	m_oSelectedCard = _oCard

func _on_unit_selected(_nUnit: Unit):
	if m_oSelectedCard:
		m_oSelectedCard.on_unit_selected((_nUnit))

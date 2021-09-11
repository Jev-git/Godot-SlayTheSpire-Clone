extends Node2D

export var m_psCard: PackedScene
export var m_iMaximumCards: int = 10
onready var m_nCardUtil: CardUtil = get_tree().get_nodes_in_group("CardUtil")[0]
var m_aiDrawPile: Array
onready var m_aiDiscardPile = []
var m_oSelectedCard: Card

func _ready():
	m_aiDrawPile = m_nCardUtil.get_initial_deck()
	m_aiDrawPile.shuffle()

func draw_cards(_iAmount: int):
	var iCardsToDraw: int = _iAmount
	var iExtraCardsToDraw: int = 0
	
	if _iAmount > m_aiDrawPile.size():
		iCardsToDraw = m_aiDrawPile.size()
		iExtraCardsToDraw = _iAmount - m_aiDrawPile.size()
		
	for i in range(get_child_count(), get_child_count() + iCardsToDraw):
		var nCard: Card = m_psCard.instance()
		nCard.init(m_nCardUtil.get_card_data_with_id(m_aiDrawPile.pop_front()))
		add_child(nCard)
		nCard.position.x = i * nCard.m_vCardSize.x * 0.6
	
	if iExtraCardsToDraw > 0:
		move_discard_pile_to_draw_pile()
		draw_cards(iExtraCardsToDraw)

func send_used_card_to_discard_pile(_iID: int):
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

func on_unit_selected(_nUnit: Node2D):
	if m_oSelectedCard:
		m_oSelectedCard.on_unit_selected((_nUnit))

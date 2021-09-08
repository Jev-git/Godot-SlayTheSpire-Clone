extends Node2D

export var m_psCard: PackedScene
export var m_iMaximumCards: int = 10
export var m_sCardCSVPath: String
var m_aCardData
var m_oSelectedCard: Card

func _ready():
	m_aCardData = _read_card_csv_file()

func draw_cards():
	for i in range(5):
		var nCard: Card = m_psCard.instance()
		nCard.init(m_aCardData[randi() % m_aCardData.size()])
		add_child(nCard)
		nCard.position.x = i * nCard.m_vCardSize.x * 0.6

func discard():
	for nCard in get_children():
		nCard.queue_free()

func _read_card_csv_file():
	var aData = []
	var oFile: File = File.new()
	oFile.open(m_sCardCSVPath, oFile.READ)
	oFile.get_csv_line() # Skip the first line
	while !oFile.eof_reached():
		var csv = oFile.get_csv_line()
		if csv.size() > 0:
			aData.append(csv)
	oFile.close()
	return aData

func set_selected_card(_oCard: Card):
	m_oSelectedCard = _oCard

func on_unit_selected(_nUnit: Node2D):
	if m_oSelectedCard:
		m_oSelectedCard.on_unit_selected((_nUnit))

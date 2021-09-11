extends Node2D
class_name CardUtil

export var m_sDataDirPath: String = "res://Data"
export var m_sCardCSVFileName: String = "CardData.csv"
export var m_sInitialDeckCSVFileName: String = "InitialDeck.csv"

var m_aInitDeck = []
var m_aCardData = []

func _ready():
	randomize()
	m_aInitDeck = _read_csv_file(m_sInitialDeckCSVFileName)
	m_aCardData = _read_csv_file(m_sCardCSVFileName)

func _read_csv_file(_sFileName: String):
	var aData = []
	
	var oFile: File = File.new()
	oFile.open("%s/%s" % [m_sDataDirPath, _sFileName], oFile.READ)
	oFile.get_csv_line() # Skip the first line
	
	while !oFile.eof_reached():
		var csv = oFile.get_csv_line()
		aData.append(csv)
	oFile.close()
	
	var aLastLine = aData[aData.size() - 1]
	if aLastLine.size() == 1 and aLastLine[0] == "":
		aData.pop_back()
	
	return aData

func get_card_data_with_id(_iID: int):
	for data in m_aCardData:
		if int(data[0]) == _iID:
			return data

func get_initial_deck() -> Array:
	var aiDeck = []
	for aData in m_aInitDeck:
		aiDeck.append(int(aData[0]))
	return aiDeck

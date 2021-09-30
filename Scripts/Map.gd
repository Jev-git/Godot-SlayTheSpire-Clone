extends Popup

export var m_bDebugMode: bool = true
export var m_iLayer: int = 5
export var m_iMinRoomPerLayer: int = 3
export var m_iMaxRoomPerLayer: int = 4
export var m_fMinDistanceBetweenRoom: float = 50
export var m_vLayerSize: Vector2 = Vector2(320, 100)

onready var m_aiRoomCount: Array = []
onready var m_aavRoomPos: Array = []
onready var m_aaaiConnections: Array = []

func _ready():
	popup()
	
	randomize()
	_generate_random_map()
	while(_is_map_segmented()):
		_generate_random_map()
	
	for iLayer in range(m_iLayer):
		var avRoomPos: Array = []
		var fLeftBoundary: float = m_fMinDistanceBetweenRoom
		for iRoom in range(m_aiRoomCount[iLayer]):
			var vRoomPos: Vector2 = Vector2(
				(iRoom + randf() * 0.6 + 0.2) * m_vLayerSize.x / m_aiRoomCount[iLayer],
				(iLayer + randf() / 2 + 0.25) * m_vLayerSize.y
			)
			fLeftBoundary = vRoomPos.x + m_fMinDistanceBetweenRoom
			avRoomPos.append(vRoomPos)
		m_aavRoomPos.append(avRoomPos)

func _generate_random_map():
	m_aiRoomCount = []
	m_aaaiConnections = []
	
	for __ in range(m_iLayer):
		var iRoomCount: int = randi() % (m_iMaxRoomPerLayer - m_iMinRoomPerLayer + 1) + m_iMinRoomPerLayer
		m_aiRoomCount.append(iRoomCount)
	
	for iLayer in range(m_iLayer - 1):
		m_aaaiConnections.append(_create_connection_from_layer(iLayer))

func _input(event):
	if event is InputEventKey:
		if event.is_pressed() and event.get_scancode() == KEY_SPACE:
			get_tree().reload_current_scene()
	
func _draw():
	if m_bDebugMode:
		for iLayer in range(m_iLayer):
			draw_rect(Rect2(0, iLayer * m_vLayerSize.y, m_vLayerSize.x, m_vLayerSize.y), Color.blue, false)

	for layer in m_aavRoomPos:
		for vRoomPos in layer:
			draw_circle(vRoomPos, 5, Color.red)
	
	for iLayer in range(m_iLayer - 1):
		for iRoom in range(m_aiRoomCount[iLayer]):
			for iTargetRoom in m_aaaiConnections[iLayer][iRoom]:
				draw_line(m_aavRoomPos[iLayer][iRoom], m_aavRoomPos[iLayer + 1][iTargetRoom], Color.white)

func _create_connection_from_layer(_iUpperLayerIndex: int):
	var iUpperLayerRoomCount: int = m_aiRoomCount[_iUpperLayerIndex]
	var iLowerLayerRoomCount: int = m_aiRoomCount[_iUpperLayerIndex + 1]
	
	var aaiConnections: Array = []
	for __ in range(iUpperLayerRoomCount):
		aaiConnections.append([])
	
	aaiConnections[0].append(0)
	aaiConnections[iUpperLayerRoomCount - 1].append(iLowerLayerRoomCount - 1)
	
	var iLowerLeftBoundaryIndex: int = 0
	for iRoomIndex in range(1, iUpperLayerRoomCount - 1):
		var iTargetRoomIndex: int = min(randi() % 2 + iLowerLeftBoundaryIndex, iLowerLayerRoomCount - 1)
		aaiConnections[iRoomIndex].append(iTargetRoomIndex)
		iLowerLeftBoundaryIndex = iTargetRoomIndex
	for iRoomIndex in range(iLowerLeftBoundaryIndex + 1, iLowerLayerRoomCount - 1):
		aaiConnections[iUpperLayerRoomCount - 1].append(iRoomIndex)
	
	return aaiConnections

func _is_map_segmented():
	for iStartingRoomIndex in range(m_aiRoomCount[0]):
		var bReachedAllEndRooms: bool = true
		var aiReachableEndRoomIndices: Array = _get_reachable_end_room_indices([], iStartingRoomIndex)
		for iEndRoomIndex in range(m_aiRoomCount[m_iLayer - 1]):
			if !aiReachableEndRoomIndices.has(iEndRoomIndex):
				bReachedAllEndRooms = false
				break
		if bReachedAllEndRooms:
			return false
	return true

func _get_reachable_end_room_indices(_aiPath: Array, _iCurrentRoomIndex: int) -> Array:
	_aiPath.append(_iCurrentRoomIndex)
	if _aiPath.size() == m_iLayer - 1:
		return m_aaaiConnections[m_iLayer - 2][_iCurrentRoomIndex]
	else:
		var aiReachableEndRoomIndices: Array = []
		for iNextRoomIndex in m_aaaiConnections[_aiPath.size() - 1][_iCurrentRoomIndex]:
			aiReachableEndRoomIndices.append_array(_get_reachable_end_room_indices(_aiPath.duplicate(), iNextRoomIndex))
		return aiReachableEndRoomIndices

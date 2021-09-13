extends Node2D
class_name Card

enum TARGET_TYPE {PLAYER, ENEMY_SINGLE, ENEMY_ALL}
enum CARD_TYPE {ATTACK, SKILL, POWER}
var TARGET_TYPE_DICT = {
	"SELF": TARGET_TYPE.PLAYER,
	"ENEMY_SINGLE": TARGET_TYPE.ENEMY_SINGLE,
	"ENEMY_ALL": TARGET_TYPE.ENEMY_ALL
}
var CARD_TYPE_DICT = {
	"ATTACK": CARD_TYPE.ATTACK,
	"SKILL": CARD_TYPE.SKILL,
	"POWER": CARD_TYPE.POWER
}

# Card params
onready var m_iID: int
var m_tTexture: Texture
var m_iCardType: int
var m_iTargetType: int
var m_iEnergyCost: int
var m_aiParams = []

export var m_psTextBubble: PackedScene
var m_sTextureDirPath: String = "res://Assets"

onready var m_nUnits: Node2D = get_tree().get_nodes_in_group("Units")[0]
onready var m_nPlayer: Unit = m_nUnits.get_node("Player")
onready var m_nEnemies: Node2D = m_nUnits.get_node("Enemies")
onready var m_nCards: Node2D = get_tree().get_nodes_in_group("Cards")[0]
onready var m_nPlayerEnergy: PlayerEnergy = get_tree().get_nodes_in_group("Energy")[0]

enum STATE {DEFAULT, HOVERING, SELECTING}
onready var m_iState = STATE.DEFAULT
onready var m_bIsSelecting = false
onready var m_iHoverOffset: int = 10
var m_vCardSize: Vector2

func init(_aCardData: Array):
	m_iID = int(_aCardData.pop_front())
	$TextureRect.texture = load("%s/%s.webp" % [m_sTextureDirPath, _aCardData.pop_front()])
	m_iCardType = CARD_TYPE_DICT[_aCardData.pop_front()]
	m_iTargetType = TARGET_TYPE_DICT[_aCardData.pop_front()]
	m_iEnergyCost = int(_aCardData.pop_front())
	m_aiParams.append(int(_aCardData.pop_front()))
	m_aiParams.append(int(_aCardData.pop_front()))
	$TextureRect.connect("mouse_entered", self, "_on_mouse_entered")
	$TextureRect.connect("mouse_exited", self, "_on_mouse_exited")

	m_vCardSize = $TextureRect.get_texture().get_size()

func _draw():
	if m_bIsSelecting:
		draw_rect(Rect2(Vector2.ZERO, m_vCardSize), Color.green, false)

func _process(delta):
	update()

func _input(event):
	if event is InputEventMouse:
		if m_iState == STATE.HOVERING and event.is_pressed() and event.get_button_mask() == BUTTON_LEFT:
			change_state(STATE.SELECTING)
		elif m_iState == STATE.SELECTING and event.is_pressed() and event.get_button_mask() == BUTTON_RIGHT:
			change_state(STATE.DEFAULT)

func _on_mouse_entered():
	if m_iState == STATE.DEFAULT:
		change_state(STATE.HOVERING)

func _on_mouse_exited():
	if m_iState == STATE.HOVERING:
		change_state(STATE.DEFAULT)

func _highlight_possible_target(_bIsHighlighting: bool):
	if m_iTargetType == TARGET_TYPE.PLAYER:
		var nPlayer: Unit = m_nUnits.get_node("Player")
		nPlayer.set_highlight(_bIsHighlighting)
	else:
		var anEnemies = m_nUnits.get_node("Enemies").get_children()
		for nEnemy in anEnemies:
			nEnemy.set_highlight(_bIsHighlighting, m_iTargetType == TARGET_TYPE.ENEMY_ALL)

func change_state(_iNewState: int):
	match m_iState:
		STATE.DEFAULT:
			if _iNewState == STATE.HOVERING: # Mouse over the card
				global_position.y -= m_iHoverOffset
				z_index = 10
		STATE.HOVERING:
			if _iNewState == STATE.DEFAULT: # Mouse exit the card
				global_position.y += m_iHoverOffset
				z_index = 0
			elif _iNewState == STATE.SELECTING: # Select a card
				if m_iEnergyCost > m_nPlayerEnergy.get_current_energy():
					var nTextBubble: TextBubble = m_psTextBubble.instance()
					nTextBubble.display_text("Not enough energy")
					m_nPlayer.add_child(nTextBubble)
					return
				
				# Deselect all other cards
				for nCard in m_nCards.get_children():
					if nCard.m_iState == STATE.SELECTING:
						nCard.change_state(STATE.DEFAULT)
						break
				
				get_parent().set_selected_card(self)
				m_bIsSelecting = true
				_highlight_possible_target(true)
		STATE.SELECTING:
			if _iNewState == STATE.DEFAULT: # Deselect the card
				m_bIsSelecting = false
				z_index = 0
				_highlight_possible_target(false)
				global_position.y += m_iHoverOffset
	m_iState = _iNewState

func on_unit_selected(_nUnit: Node2D):
	match m_iCardType:
		CARD_TYPE.ATTACK:
			if m_iTargetType == TARGET_TYPE.ENEMY_SINGLE:
				_nUnit.take_damage(m_aiParams[0])
			else:
				for nEnemy in m_nEnemies.get_children():
					nEnemy.take_damage(m_aiParams[0])
			m_nPlayer.gain_block(m_aiParams[1])
		CARD_TYPE.SKILL:
			m_nPlayer.gain_block(m_aiParams[0])
	get_parent().send_used_card_to_discard_pile(m_iID)
	get_parent().set_selected_card(null)
	_highlight_possible_target(false)
	m_nPlayerEnergy.use_energy(m_iEnergyCost)
	queue_free()

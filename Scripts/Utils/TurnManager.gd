extends Node2D
class_name TurnManager

export var m_psEnemy: PackedScene

onready var m_nCards = get_tree().get_nodes_in_group("Cards")[0]
onready var m_nUnits = get_tree().get_nodes_in_group("Units")[0]
onready var m_nPlayer: Player = m_nUnits.get_node("Player")
onready var m_nEnemies: Node2D = m_nUnits.get_node("Enemies")
onready var m_nPlayerEnergy: PlayerEnergy = get_tree().get_nodes_in_group("Energy")[0]
onready var m_nEndTurnButton: Button = get_tree().get_nodes_in_group("EndTurnButton")[0]
onready var m_anUIButtons: Array = get_tree().get_nodes_in_group("UIButtons")

onready var m_iEnemyLeft: int = m_nEnemies.get_child_count()
onready var m_nCardRewardPopup: CardRewardPopup = get_parent().get_node("CardRewardPopup")
onready var m_nGameOverPopup: Node2D = get_parent().get_node("GameOverPopup")

func _ready():
	m_nCardRewardPopup.connect("reward_selected", self, "_reload_scene")
	m_nEndTurnButton.connect("pressed", self, "_end_player_turn")
	yield(m_nPlayerEnergy, "ready")
	m_iEnemyLeft = randi() % 3 + 1
	
	m_nPlayer.connect("die", m_nGameOverPopup, "show_popup")
	for i in range(m_iEnemyLeft):
		var nEnemy = m_psEnemy.instance()
		m_nEnemies.add_child(nEnemy)
		nEnemy.position.x = i * 128
		nEnemy.connect("end_turn", self, "_end_enemies_turn")
		nEnemy.connect("die", self, "_on_enemy_die")
	m_nCards.init()
	_start_player_turn()

func _reload_scene():
	PersistantData.save_data()
	get_tree().reload_current_scene()

func _start_player_turn():
	m_nPlayer.set_block(0)
	m_nCards.draw_cards(min(5, CardUtil.get_deck().size()))
	m_nPlayerEnergy.reset_turn()

func _end_player_turn():
	m_nCards.discard_hand()
	m_nCards.set_selected_card(null)
	m_nPlayer.reduce_effect_duration()
	
	var nMetalFX: MetallicizeFX = m_nPlayer.get_effect(UnitEffectUtil.EFFECT_TYPES.METALLICIZE)
	if nMetalFX:
		m_nPlayer.gain_block(nMetalFX.m_iStackCount)
	
	m_nPlayer.set_highlight(false)
	for nEnemy in m_nEnemies.get_children():
		nEnemy.set_highlight(false)
	
	for nUIButton in m_anUIButtons:
		nUIButton.visible = false
	
	_start_enemies_turn()

func _start_enemies_turn():
	m_nEnemies.get_child(0).start_turn()

func _end_enemies_turn():
	if m_nPlayer.m_iCurrentHP <= 0:
		return
	
	for nUIButton in m_anUIButtons:
		nUIButton.visible = true
	
	for nEnemy in m_nEnemies.get_children():
		nEnemy.reduce_effect_duration()
	
	_start_player_turn()

func _on_enemy_die(_nEnemy: Unit):
	m_iEnemyLeft -= 1
	_nEnemy.queue_free()
	if m_iEnemyLeft == 0:
		m_nCardRewardPopup.show()
		m_nCards.discard_hand()

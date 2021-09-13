extends Node2D
class_name CombatEndPopup

onready var m_nDialog: AcceptDialog = $AcceptDialog
onready var m_nUnits: Node2D = get_tree().get_nodes_in_group("Units")[0]
onready var m_nPlayer: Unit = m_nUnits.get_node("Player")
onready var m_nEnemies: Node2D = m_nUnits.get_node("Enemies")
onready var m_iEnemyLeft: int = m_nEnemies.get_child_count()

func _ready():
	m_nPlayer.connect("die", self, "_on_player_die")
	for nEnemy in m_nEnemies.get_children():
		nEnemy.connect("die", self, "_on_enemy_die")
	
	m_nDialog.connect("confirmed", self, "_restart")
	m_nDialog.set_exclusive(true)

func _on_player_die(_nPlayer):
	get_tree().paused = true
	m_nDialog.window_title = "You lose"
	m_nDialog.popup_centered()

func _on_enemy_die(_nEnemy: Unit):
	m_iEnemyLeft -= 1
	_nEnemy.queue_free()
	if m_iEnemyLeft == 0:
		get_tree().paused = true
		m_nDialog.window_title = "You win"
		m_nDialog.popup_centered()

func _restart():
	get_tree().paused = false
	get_tree().reload_current_scene()

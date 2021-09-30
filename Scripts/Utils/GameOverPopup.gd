extends Node2D

onready var m_nDialog: AcceptDialog = $AcceptDialog

func _ready():
	m_nDialog.connect("confirmed", self, "_restart")
	m_nDialog.set_exclusive(true)

func show_popup(_nPlayer: Player):
	get_tree().paused = true
	m_nDialog.window_title = "You lose"
	m_nDialog.popup_centered()

func _restart():
	CardUtil.reset_to_initial_deck()
	get_tree().paused = false
	get_tree().reload_current_scene()

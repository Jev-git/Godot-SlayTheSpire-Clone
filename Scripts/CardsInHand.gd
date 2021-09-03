extends Node2D

export var m_psCard: PackedScene
export var m_iMaximumCards: int = 10
export var m_iCardWidth: int = 64
export var m_iDistanceBetweenCard: int = 10

func _ready():
	draw_cards()

func draw_cards():
	for i in range(5):
		var nCard: Node2D = m_psCard.instance()
		nCard.position.x = i * (m_iCardWidth + m_iDistanceBetweenCard)
		add_child(nCard)

func discard():
	for nCard in get_children():
		nCard.queue_free()
	yield(get_tree().create_timer(1.0), "timeout")
	draw_cards()

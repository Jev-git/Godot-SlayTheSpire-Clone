extends Node2D

export var m_psCard: PackedScene
export var m_iMaximumCards: int = 10

func _ready():
	draw_cards()

func draw_cards():
	for i in range(5):
		var nCard: Node2D = m_psCard.instance()
		add_child(nCard)
		nCard.position.x = i * nCard.m_vCardSize.x * 0.6

func discard():
	for nCard in get_children():
		nCard.queue_free()
	yield(get_tree().create_timer(1.0), "timeout")
	draw_cards()

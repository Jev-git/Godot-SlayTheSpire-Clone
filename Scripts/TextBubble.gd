extends Node2D
class_name TextBubble

export var m_fFlyDownSpeed: float = 100
var m_bFlyingUp: bool

func _ready():
	$Timer.connect("timeout", self, "queue_free")

func display_damage(_iDamageAmount: int, _iIsHPDamage: bool = true):
	if _iIsHPDamage:
		$HPDamageText.text = "-%s" % _iDamageAmount
	else:
		$BlockDamageText.text = "-%s" % _iDamageAmount

func display_text(_sText: String):
	$NormalText.text = _sText
	m_bFlyingUp = true

func _process(delta):
	position.y += delta * m_fFlyDownSpeed * (-1 if m_bFlyingUp else 1)

extends Node2D
class_name DamageBubble

export var m_fFlyDownSpeed: float = 100

func _ready():
	$Timer.connect("timeout", self, "queue_free")

func init(_iDamageAmount: int, _iIsHPDamage: bool = true):
	if _iIsHPDamage:
		$HPDamageText.text = "-%s" % _iDamageAmount
	else:
		$BlockDamageText.text = "-%s" % _iDamageAmount

func _process(delta):
	position.y += delta * m_fFlyDownSpeed

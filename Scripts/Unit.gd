extends Node2D
class_name Unit

enum STATE {DEFAULT, HIGHLIGHTING, HOVERING}
onready var m_iState: int = STATE.DEFAULT
onready var m_bHighlightAllEnemies: bool = false
onready var m_nUnits: Node2D = get_tree().get_nodes_in_group("Units")[0]
onready var m_nPlayer: Unit = m_nUnits.get_node("Player")
onready var m_nEnemies: Node2D = m_nUnits.get_node("Enemies")

export var m_iMaxHP: int = 70
onready var m_iCurrentHP: int
onready var m_iBlock: int = 0
onready var m_nHPLabel = $HPLabel
onready var m_nBlockLabel = $BlockLabel

onready var m_vPositionOffset = Vector2.ZERO
onready var m_nAnimPlayer = $AnimationPlayer

export var m_psTextBubble: PackedScene

onready var m_vTextureSize: Vector2 = $TextureRect.get_texture().get_size()

onready var m_nEffects: Node2D = $Effects

signal selected(_nSelf)
signal die(_nSelf)

func _ready():
	$TextureRect.connect("mouse_entered", self, "_on_mouse_entered")
	$TextureRect.connect("mouse_exited", self, "_on_mouse_exited")
	
	set_hp(m_iMaxHP)

func _process(delta):
	update()

func _draw():
	match m_iState:
		STATE.HIGHLIGHTING:
			draw_rect(Rect2(- m_vTextureSize * 0.6, m_vTextureSize * 1.2), Color.green, false)
		STATE.HOVERING:
			draw_rect(Rect2(- m_vTextureSize * 0.6, m_vTextureSize * 1.2), Color.yellow, false)

func _input(event):
	if event is InputEventMouse:
		if m_iState == STATE.HOVERING and event.is_pressed() and event.get_button_mask() == BUTTON_LEFT:
			emit_signal("selected", self)

func set_highlight(_bIsHighlighting: bool, _bHighlightAllEnemies: bool = false):
	m_bHighlightAllEnemies = _bHighlightAllEnemies
	match m_iState:
		STATE.DEFAULT:
			if _bIsHighlighting:
				m_iState = STATE.HIGHLIGHTING
		_:
			if !_bIsHighlighting:
				m_iState = STATE.DEFAULT

func _on_mouse_entered():
	if m_bHighlightAllEnemies:
		for nEnemy in m_nEnemies.get_children():
			if nEnemy.m_iState == STATE.HIGHLIGHTING:
				nEnemy.m_iState = STATE.HOVERING
	else:
		if m_iState == STATE.HIGHLIGHTING:
			m_iState = STATE.HOVERING

func _on_mouse_exited():
	if m_bHighlightAllEnemies:
		for nEnemy in m_nEnemies.get_children():
			if nEnemy.m_iState == STATE.HOVERING:
				nEnemy.m_iState = STATE.HIGHLIGHTING
	else:
		if m_iState == STATE.HOVERING:
			m_iState = STATE.HIGHLIGHTING

func set_hp(_iHP: int):
	m_iCurrentHP = _iHP
	if m_iCurrentHP <= 0:
		m_nHPLabel.text = ""
		emit_signal("die", self)
	else:
		m_nHPLabel.text = "%s/%s" % [m_iCurrentHP, m_iMaxHP]

func take_damage(_iDamage: int):
	var nVulnerableFX: VulnerableFX = get_effect(UnitEffectUtil.EFFECT_TYPES.VULNERABLE)
	if nVulnerableFX:
		_iDamage = nVulnerableFX.get_amped_dmg(_iDamage)
	
	var iDamageToHP: int = _iDamage
	
	if m_iBlock > 0:
		if _iDamage > m_iBlock:
			iDamageToHP = _iDamage - m_iBlock
			_create_damage_bubble(m_iBlock, false)
			set_block(0)
		else:
			iDamageToHP = 0
			_create_damage_bubble(_iDamage, false)
			set_block(m_iBlock - _iDamage)
	
	if iDamageToHP > 0:
		m_nAnimPlayer.play("Shake")
		set_hp(m_iCurrentHP - iDamageToHP)
		yield(get_tree().create_timer(0.1), "timeout")
		_create_damage_bubble(iDamageToHP, true)

func deal_damage(_iDamage: int, _nTarget: Unit):
	var nStrenghFX: StrengthFX = get_effect(UnitEffectUtil.EFFECT_TYPES.STRENGTH)
	var nWeakFX: WeakFX = get_effect(UnitEffectUtil.EFFECT_TYPES.WEAK)
	if nStrenghFX:
		_iDamage = nStrenghFX.get_amped_dmg(_iDamage)
	if nWeakFX:
		_iDamage = nWeakFX.get_weaken_dmg(_iDamage)
	_nTarget.take_damage(_iDamage)

func get_effect(_iEffectType: int) -> UnitEffect:
	for nEffect in m_nEffects.get_children():
		if nEffect.get_effect_type() == _iEffectType:
			return nEffect
	return null

func gain_block(_iBlock: int):
	set_block(m_iBlock + _iBlock)

func set_block(_iBlock: int):
	if _iBlock <= 0:
		m_iBlock = 0
		m_nBlockLabel.text = ""
	else:
		m_iBlock = _iBlock
		m_nBlockLabel.text = String(m_iBlock)

func _create_damage_bubble(_iDamage: int, _bIsHPDamage: bool):
	var nTextBubble: TextBubble = m_psTextBubble.instance()
	nTextBubble.display_damage(_iDamage, _bIsHPDamage)
	$DamageBubble.add_child(nTextBubble)

func apply_effect(_iEffectType: int, _iDuration: int):
	m_nEffects.apply_effect(_iEffectType, _iDuration)

func reduce_effect_duration():
	m_nEffects.reduce_effect_duration()

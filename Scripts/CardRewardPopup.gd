extends Node2D
class_name CardRewardPopup

export var m_psCardReward: PackedScene
signal reward_selected

func show():
	visible = true
	$Popup.popup_centered()
	for nPos2D in $Popup/Cards.get_children():
		var nCard: CardReward = m_psCardReward.instance()
		nCard.init(CardUtil.get_random_card_data())
		nCard.connect("selected", self, "_on_card_selected")
		nPos2D.add_child(nCard)

func _on_card_selected(_iID: int):
	visible = false
	$Popup.hide()
	for nPos2D in $Popup/Cards.get_children():
		nPos2D.get_child(0).queue_free()
	
	CardUtil.add_reward_card_to_deck(_iID)
	emit_signal("reward_selected")

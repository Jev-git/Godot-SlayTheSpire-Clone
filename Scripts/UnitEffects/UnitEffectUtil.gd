extends Node2D

var m_sEffectScenePath: String = "res://Scenes/Effects"

enum EFFECT_TYPES {
	VULNERABLE,
	WEAK,
	STRENGTH,
	METALLICIZE
}

var EFFECT_SCENE_NAME = [
	"VulnerableFX.tscn",
	"WeakFX.tscn",
	"StrengthFX.tscn",
	"MetallicizeFX.tscn"
]

func get_effect_scene_name(_iEffectType: int) -> String:
	return "%s/%s" % [m_sEffectScenePath, EFFECT_SCENE_NAME[_iEffectType]]

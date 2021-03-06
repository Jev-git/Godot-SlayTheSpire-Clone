# Doing
* Map
    * ~~Random generation~~
    * ~~(optional) prevent segmented map: map consists of completely separated path~~
    * Display current room
    * Choose reward -> display map -> choose room -> reload combat
# Time
September 2021
# MVP (done)
~~Able to fight with the enemy in a single combat.~~

* ~~Per Turn:~~
    * ~~Able to draw cards~~
    * ~~Able to discard cards~~
    * ~~Able to pick and choose target for a card (self, enemy single, enemy all)~~
    * ~~Attack cards that can damage unit's HP~~
    * ~~Skill cards that can provide block to negate damage from attack cards.~~
    * ~~Energy~~
    * ~~Consistant deck:~~
* ~~Per Combat:~~
    * ~~Lose condition~~
    * ~~Win condition~~

# Checklist
Features ordered by neccessity, technical difficulty and the amount of time required.

* ~~Per Combat status effect, buff and debuff~~
    * ~~FX that get reduced by 1 each turn.~~
    * ~~Power cards.~~
* Combat reward:
    * ~~New card~~
    * Money
* Per Run:
    * Map
* Campfire
    * Rest
    * Smith
    * Remove card
* Shop
    * New card
    * Remove card
* Potion
    * Receive after combat
    * Buy at shop
* Relic

# How to add new effect
* Add `enum` and mapping to effect scene in `UnitEffectUtil.gd`
```gdscript
enum EFFECT_TYPES {
    ...,
    NEW_EFFECT
}

var EFFECT_SCENE_NAME = [
    ...,
    "NewEffectFX.tscn"
]
```
* Duplicate from a previous effect scene, and change the script's name accordingly.
* Assign appropriate `m_iType` and `m_bHasDuration`.

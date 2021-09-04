# Doing
* Able to choose target for a card:
    * If a card require a single target, then highlight the target enemy on mouse hover.
    * ~~Use godot's `_draw()` function: draw a line from the selected card to the mouse cursor.~~
    * If the card target is on self, or all enemy, then just highlight the target(s).
# Time
September 2021
# MVP
Able to fight with the enemy in a single combat.

* Prep:
    * Take about 20 or less normal cards (card with no status effect, buff or debuff).

* Per Turn:
    * Able to draw cards
    * Able to discard cards
    * Able to pick and choose target for a card (self, enemy single, enemy all)
* Per Combat:
    * Hooks:
        * Combat start
        * Combat end
        * Turn start
        * Turn end
    * Enemy planning
    * Lose condition
    * Win condition

# Checklist
Features ordered by neccessity, technical difficulty and the amount of time required.

* Per Combat status effect, buff and debuff
    * FX that get reduced by 1 each turn.
    * Power cards.
* Combat reward:
    * New card
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
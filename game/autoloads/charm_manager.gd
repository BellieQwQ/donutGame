#extends Node
#
#enum CharmName { NONE, HEAVY_FISTS, LIGHT_WEIGHT }
#var charmEquipped = CharmName.NONE
#
## Regular player constant without charms
#
#const BASE_JUMP_HEIGHT = 800
#const BASE_TIME_TO_PEAK = 0.48
#const BASE_TIME_TO_GROUND = 0.42
#
## Charm status manager
#
#func equipCharm(id):
	#charmEquipped = id
	#
#func unequip():
	#charmEquipped = CharmName.NONE
	#
#func currentCharm(id):
	#return charmEquipped == id
	#
## Apply charm modifications
#
#func applyPlayerMods(player):
	#var jumpHeight = BASE_JUMP_HEIGHT
	#var timeToPeak = BASE_TIME_TO_PEAK
	#var timeToDescent = BASE_TIME_TO_GROUND
	#
	#if currentCharm(CharmName.LIGHT_WEIGHT):
		#jumpHeight -= 200
		#timeToPeak -= 0.10
		#timeToDescent -= 0.09
		#player.maxJumps = 2
	#else:
		#player.maxJumps = 1
		#
	#player.jumpHeight = jumpHeight
	#player.timeToJumpPeak = timeToPeak
	#player.timeToDescent = timeToDescent
	#
	#player.jumpVelocity = ((2.0 * jumpHeight) / (timeToPeak)) * -1
	#player.jumpGravity = ((-2.0 * jumpHeight) / (timeToPeak * timeToPeak)) * -1 * 1.2
	#player.fallGravity = ((-2.0 * jumpHeight) / (timeToDescent * timeToDescent)) * -1 * 1.4
	
extends Node

enum CharmName { NONE, HEAVY_FISTS, LIGHT_WEIGHT }
var charmEquipped: CharmName = CharmName.NONE

# Mantén una referencia al/los player(s) (aquí 1 para simpleza)
var _player: Player = null

# --- Constantes base ---
const BASE_JUMP_HEIGHT = 800
const BASE_TIME_TO_PEAK = 0.48
const BASE_TIME_TO_GROUND = 0.42

# --- API pública ---
func register_player(p: Player) -> void:
	_player = p
	applyPlayerMods(p)

func equipCharm(id: CharmName) -> void:
	charmEquipped = id
	_apply_to_registered()

func unequip() -> void:
	charmEquipped = CharmName.NONE
	_apply_to_registered()

func currentCharm(id: CharmName) -> bool:
	return charmEquipped == id

func toggle_lightweight() -> void:
	if charmEquipped == CharmName.LIGHT_WEIGHT:
		charmEquipped = CharmName.NONE
	else:
		charmEquipped = CharmName.LIGHT_WEIGHT
	_apply_to_registered()

# --- Input global (funciona porque es Autoload) ---
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("changeCharm"):
		toggle_lightweight()

# --- Aplicar modificaciones ---
func _apply_to_registered() -> void:
	if _player and is_instance_valid(_player):
		applyPlayerMods(_player)

func applyPlayerMods(player: Player) -> void:
	var jumpHeight = BASE_JUMP_HEIGHT
	var timeToPeak = BASE_TIME_TO_PEAK
	var timeToDescent = BASE_TIME_TO_GROUND

	if currentCharm(CharmName.LIGHT_WEIGHT):
		jumpHeight -= 200
		timeToPeak -= 0.10
		timeToDescent -= 0.09
		player.maxJumps = 2
	else:
		player.maxJumps = 1

	player.jumpHeight = jumpHeight
	player.timeToJumpPeak = timeToPeak
	player.timeToDescent = timeToDescent

	player.jumpVelocity = ((2.0 * jumpHeight) / (timeToPeak)) * -1
	player.jumpGravity = ((-2.0 * jumpHeight) / (timeToPeak * timeToPeak)) * -1 * 1.2
	player.fallGravity = ((-2.0 * jumpHeight) / (timeToDescent * timeToDescent)) * -1 * 1.4

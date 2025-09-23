extends Node

enum CharmName { NONE, HEAVY_FISTS, LIGHT_WEIGHT }
var charmEquipped = CharmName.NONE

# Regular player constant without charms

const BASE_JUMP_HEIGHT = 900
const BASE_TIME_TO_PEAK = 0.48
const BASE_TIME_TO_GROUND = 0.42

# Charm status manager

func equipCharm(id):
	charmEquipped = id
	
func unequip():
	charmEquipped = CharmName.NONE
	
func currentCharm(id):
	return charmEquipped == id
	
# Apply charm modifications

func applyPlayerMods(player):
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

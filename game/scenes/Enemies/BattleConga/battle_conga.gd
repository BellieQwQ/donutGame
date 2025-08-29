extends Enemy

const SPEED = 500
const DECELERATION = 3000

var stateMachine: EnemyStateMachine

var facingLeft = true
var direction = 1

var jumpHeight = 800 
var timeToJumpPeak = 0.55
var timeToDescent = 1.2

var jumpVelocity = ((2.0 * jumpHeight) / (timeToJumpPeak)) * -1
var jumpGravity = ((-2.0 * jumpHeight) / (timeToJumpPeak * timeToJumpPeak)) * -1 * 1.2
var fallGravity = ((-2.0 * jumpHeight) / (timeToDescent * timeToDescent)) * -1 * 1.4

@export var bullet : PackedScene

@onready var animator = $FlipRoot/AnimatedSprite2D
@onready var bulletSpawner = $FlipRoot/bulletSpawner
@onready var hitbox = $CollisionShape2D
@onready var hurtbox = $Hurtbox
@onready var longPlayerDetector = $FlipRoot/LongPlayerDetector
@onready var shortPlayerDetector = $FlipRoot/ShortPlayerDetector
@onready var shootTimer = $ShootTimer
@onready var player = get_tree().get_first_node_in_group("player")

func getShootDirection(elevationDegree):
	var elevation = deg_to_rad(elevationDegree)
	var direction = Vector2.RIGHT.rotated(-elevation)
	if facingLeft:
		direction = Vector2.LEFT.rotated(elevation)
	return direction.normalized()

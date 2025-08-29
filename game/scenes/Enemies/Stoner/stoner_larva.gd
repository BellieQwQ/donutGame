extends Enemy

const SPEED = 1200
const ACCELERATION = 2000
const DECELERATION = 4000

var direction = -1
var isMovingLeft = true

var jumpHeight = 400 
var timeToJumpPeak = 0.5
var timeToDescent = 0.45

var jumpVelocity = ((2.0 * jumpHeight) / (timeToJumpPeak)) * -1
var jumpGravity = ((-2.0 * jumpHeight) / (timeToJumpPeak * timeToJumpPeak)) * -1 * 1.2
var fallGravity = ((-2.0 * jumpHeight) / (timeToDescent * timeToDescent)) * -1 * 1.4

@onready var animator = $AnimatedSprite2D
@onready var hitbox = $CollisionShape2D
@onready var hurtbox = $Hurtbox
@onready var player = get_tree().get_first_node_in_group("player")

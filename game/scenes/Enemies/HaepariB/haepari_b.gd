extends Enemy

const SPEED = 500
const DECELERATION = 3000

var direction = -1
var isMovingLeft = true

var player: Player

var jumpHeight = 1000
var timeToJumpPeak = 0.55
var timeToDescent = 1.1

var jumpVelocity = ((2.0 * jumpHeight) / (timeToJumpPeak)) * -1
var jumpGravity = ((-2.0 * jumpHeight) / (timeToJumpPeak * timeToJumpPeak)) * -1 * 1.2
var fallGravity = ((-2.0 * jumpHeight) / (timeToDescent * timeToDescent)) * -1 * 1.4

@onready var animator = $AnimatedSprite2D
@onready var hitbox = $CollisionShape2D
@onready var hurtbox = $Hurtbox
@onready var playerDetector = $PlayerDetector
@onready var floorDetector = $FloorDetector
@onready var stateMachine = $EnemyStateMachine

func _ready():
	playerDetector.body_entered.connect(on_player_entered)
	playerDetector.body_exited.connect(on_player_exited)

func on_player_entered(body):
	if body.is_in_group("player"):
		player = body as Player
		stateMachine.changeState("Idle")

func on_player_exited(body):
	if body == player:
		player = null
		stateMachine.changeState("Move")
	else:
		player = null

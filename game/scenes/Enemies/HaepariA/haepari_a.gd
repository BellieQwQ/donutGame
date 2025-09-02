extends Enemy

const SPEED = 500

var player : Player

var direction = -1
var isMovingLeft = true

var jumpHeight = 800 
var timeToJumpPeak = 0.55
var timeToDescent = 1.2

var jumpVelocity = ((2.0 * jumpHeight) / (timeToJumpPeak)) * -1
var jumpGravity = ((-2.0 * jumpHeight) / (timeToJumpPeak * timeToJumpPeak)) * -1 * 1.2
var fallGravity = ((-2.0 * jumpHeight) / (timeToDescent * timeToDescent)) * -1 * 1.4

@onready var animator = $AnimatedSprite2D
@onready var hitbox = $CollisionShape2D
@onready var hurtbox = $Hurtbox

func _on_hurtbox_body_entered(body):
	if body is Player and !body.invincible:
		var enemyPosition = sign(body.global_position.x - self.global_position.x)
		body.knockbackDirection = enemyPosition
		body.emit_signal("playerHurt")
		print("PLAYER DETECTED")

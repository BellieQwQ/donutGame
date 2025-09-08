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

var damageType = Player.DamageType.ELECTRIC

@onready var animator = $AnimatedSprite2D
@onready var hitbox = $CollisionShape2D
@onready var hurtbox = $Hurtbox
@onready var hurtboxTimer = $HurtboxTimer

func _on_hurtbox_body_entered(body):
	if body is Player and !body.invincible:
		body.lastDamageReceived = damageType
		
		var enemyPosition = sign(body.global_position.x - self.global_position.x)
		body.knockbackDirection = enemyPosition
		body.emit_signal("playerHurt")
		print("PLAYER DETECTED")
		hurtboxTimer.start()
		hurtbox.set_deferred("monitoring", false)
	
func _on_hurtbox_timer_timeout():
	hurtbox.set_deferred("monitoring", true)

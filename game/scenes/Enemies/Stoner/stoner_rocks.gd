extends CharacterBody2D

@export var initialVelocity = Vector2.ZERO
@export var gravity = 4000

func _ready():
	
	velocity = initialVelocity

func _physics_process(delta):
	
	if is_on_floor():
		queue_free()
		return
		
	velocity.y += gravity * delta
	move_and_slide()
	
func _on_hurtbox_body_entered(body):
	if body is Player and !body.invincible:
		var enemyPosition = sign(body.global_position.x - self.global_position.x)
		body.knockbackDirection = enemyPosition
		body.emit_signal("playerHurt")
		print("PLAYER DETECTED")
		queue_free()

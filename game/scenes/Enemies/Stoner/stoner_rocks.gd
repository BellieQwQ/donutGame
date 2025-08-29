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
	if body.is_in_group("player"):
		queue_free()

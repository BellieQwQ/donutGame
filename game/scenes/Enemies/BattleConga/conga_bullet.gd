extends CharacterBody2D

@onready var normalHitbox = $BulletHurtbox/CollisionShape2D
@onready var explosionHitbox = $ExplosionHurbox/CollisionShape2D
@onready var explosionTimer = $ExplosionDuration
@onready var animator = $AnimatedSprite2D
@onready var FXmanager = $AnimationPlayer

@export var initialVelocity = Vector2.ZERO
@export var gravity = 4000

var exploding = false

func _ready():
	velocity = initialVelocity

func _physics_process(delta):
	
	if is_on_floor():
		explode()
		return
		
	velocity.y += gravity * delta
	move_and_slide()
	
func explode():
	if exploding:
		return
	exploding = true
	velocity = Vector2.ZERO
	normalHitbox.set_deferred("disabled", true)
	explosionHitbox.set_deferred("disabled", false)
	animator.play("explosion")
	explosionTimer.start()
	FXmanager.play("explosionFX")
	
func _on_bullet_hurtbox_body_entered(body):
	if body.is_in_group("player"):
		explode()
	
func _on_explosion_duration_timeout():
	queue_free()

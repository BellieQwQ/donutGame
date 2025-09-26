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

var damageType = Player.DamageType.NORMAL

@export var bullet : PackedScene

@onready var animator = $FlipRoot/AnimatedSprite2D
@onready var bulletSpawner = $FlipRoot/bulletSpawner
@onready var hitbox = $CollisionShape2D
@onready var hurtbox = $Hurtbox
@onready var longPlayerDetector = $FlipRoot/LongPlayerDetector
@onready var shortPlayerDetector = $FlipRoot/ShortPlayerDetector
@onready var shootTimer = $ShootTimer
@onready var hurtboxTimer = $HurtboxTimer
@onready var player = get_tree().get_first_node_in_group("player")

func getShootDirection(elevationDegree):
	var elevation = deg_to_rad(elevationDegree)
	var bulletDirection = Vector2.RIGHT.rotated(-elevation)
	if facingLeft:
		bulletDirection = Vector2.LEFT.rotated(elevation)
	return bulletDirection.normalized()
	
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
	
func onPunched(_area):
	stateMachine.changeState("Hit")
	health -= 25
	print("Enemy HP:", health, " (-", 25, ")")
	spawnDamage()
	
func spawnDamage():
	if damageProp and spawner:
		var FX = damageProp.instantiate()
		spawner.add_child(FX)
		FX.position = Vector2.ZERO
	
		var sprite = (FX as AnimatedSprite2D)
		var animPlayer = FX.get_node("AnimationPlayer") as AnimationPlayer
		
		if sprite:
			sprite.play("25")
		if animPlayer:
			animPlayer.play("vanishing")
	
	if health <= 0:
		die()
	
func die():
	queue_free()

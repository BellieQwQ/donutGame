extends RigidBody2D

var direction = Vector2.LEFT

@export var speed = 1500.0
@onready var bulletHurtbox = $BulletHurtbox
@onready var explosionHurtbox = $ExplosionHurbox

func _ready():
	linear_velocity = direction * speed

func setDirection(dir):
	direction = dir.normalized()
	linear_velocity = direction * speed

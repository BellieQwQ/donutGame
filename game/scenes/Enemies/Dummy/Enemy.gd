class_name Enemy
extends Node

var player: Player
@export var health: int
@export var damageProp: PackedScene
@onready var stateMachine: EnemyStateMachine = $EnemyStateMachine
@onready var spawner = $DamageSpawner

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
	

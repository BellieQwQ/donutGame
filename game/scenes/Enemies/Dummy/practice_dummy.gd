extends Enemy

@onready var animator = $AnimatedSprite2D
@onready var FX = $FXManager
@onready var stateMachine = $EnemyStateMachine

func onPunched(_area):
	stateMachine.changeState("Hit")
	health -= 25
	print("Enemy HP:", health, " (-", 25, ")")
	spawnDamage()
	
func spawnDamage():
	if damageProp and spawner:
		var propFX = damageProp.instantiate()
		spawner.add_child(propFX)
		propFX.position = Vector2.ZERO
	
		var sprite = (propFX as AnimatedSprite2D)
		var animPlayer = propFX.get_node("AnimationPlayer") as AnimationPlayer
		
		if sprite:
			sprite.play("25")
		if animPlayer:
			animPlayer.play("vanishing")
	
	if health <= 0:
		die()
	
func die():
	queue_free()

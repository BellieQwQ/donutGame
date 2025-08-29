extends EnemyState

func enterState():
	enemy.animator.play("idle")  
	enemy.shootTimer.start() 

func onPhysicsProcess(delta):
	var playerIsLeft = enemy.player.global_position.x < enemy.global_position.x
	
	if playerIsLeft:
		enemy.velocity.x = enemy.direction * enemy.SPEED
	else:
		enemy.velocity.x = -1 * enemy.SPEED
	
	if !enemy.playerDetector.is_colliding():
		stateMachine.changeState("Idle")
		return
	
	applyGravity(delta)
	enemy.move_and_slide()
	
func _on_shoot_timer_timeout():
	var newBullet = enemy.bullet.instantiate()
	get_parent().add_child(newBullet)
	newBullet.global_position = enemy.bulletSpawner.global_position
	newBullet.setDirection(enemy.getShootDirection(25))

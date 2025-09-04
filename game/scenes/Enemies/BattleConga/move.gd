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
	
	if !enemy.longPlayerDetector.is_colliding():
		stateMachine.changeState("Idle")
		return
	
	applyGravity(delta)
	enemy.move_and_slide()
	
func shoot():
	var elevation = 20  
	if enemy.shortPlayerDetector.is_colliding():
		elevation = 80   
	var newBullet = enemy.bullet.instantiate()
	var direction = enemy.getShootDirection(elevation)  
	newBullet.initialVelocity = direction * 2500
	get_parent().add_child(newBullet)
	newBullet.global_position = enemy.bulletSpawner.global_position
	
func _on_shoot_timer_timeout():
	shoot()

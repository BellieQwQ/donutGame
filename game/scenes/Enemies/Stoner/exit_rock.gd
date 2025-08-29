extends EnemyState

func enterState():
	enemy.animator.play("Idle")
	enemy.velocity.y = enemy.jumpVelocity
	
func onPhysicsProcess(delta):
	if enemy.player != null:
		var pathToPlayer = enemy.player.global_position - enemy.global_position
		var directionX = sign(pathToPlayer.x)
	
		enemy.direction = directionX
	
		flip()
	
		enemy.velocity.x = enemy.jumpHeight * directionX
	
		applyGravity(delta)
		enemy.move_and_slide()
	
		if enemy.velocity.y >= 0:
			stateMachine.changeState("fall")

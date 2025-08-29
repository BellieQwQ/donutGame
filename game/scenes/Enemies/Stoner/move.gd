extends EnemyState

func enterState():
	enemy.animator.play("Idle")


func onPhysicsProcess(delta):
	if enemy.player == null:
		return
	
	var pathToPlayer = enemy.player.global_position - enemy.global_position
	var directionX = sign(pathToPlayer.x)
	
	var targetSpeed = enemy.SPEED * directionX 
	var motion = enemy.ACCELERATION if abs(targetSpeed) > abs(enemy.velocity.x) else enemy.DECELERATION
	enemy.velocity.x = move_toward(enemy.velocity.x, targetSpeed, motion * delta)
	
	if directionX != 0 and directionX != enemy.direction:
		enemy.direction = directionX
		flip()
	
	applyGravity(delta)
	enemy.move_and_slide()

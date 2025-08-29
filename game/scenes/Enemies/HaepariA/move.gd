extends EnemyState

func enterState():
	enemy.animator.play("idle")
	
	
func onPhysicsProcess(delta):
	
	if !enemy.is_on_floor() and enemy.velocity.y > 0:
		stateMachine.changeState("Fall")
		return
	
	if enemy.is_on_wall():
		enemy.direction *= -1
		flip()
	
	enemy.velocity.x = enemy.SPEED * enemy.direction
	
	applyGravity(delta)
	enemy.move_and_slide()

extends EnemyState

func enterState():
	enemy.animator.play("Idle")
	
func onPhysicsProcess(delta):
	
	if enemy.is_on_floor() and enemy.velocity.y == 0:
		stateMachine.changeState("Follow")
		return
	
	applyGravity(delta)
	enemy.move_and_slide()

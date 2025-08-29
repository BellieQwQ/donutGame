extends EnemyState

func enterState():
	enemy.animator.play("fall")
	enemy.velocity.x = 0
	
func onPhysicsProcess(delta):
	
	if enemy.is_on_floor() and enemy.velocity.y == 0:
		stateMachine.changeState("Move")
		return
	
	applyGravity(delta)
	enemy.move_and_slide()

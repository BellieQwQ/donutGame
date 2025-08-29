extends EnemyState

func enterState():
	enemy.animator.play("fall")
	
func onPhysicsProcess(delta):
	
	if enemy.is_on_floor():
		stateMachine.changeState("Move")
		return
	
	applyGravity(delta)
	enemy.move_and_slide()

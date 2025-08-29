extends EnemyState

func enterState():
	enemy.animator.play("jump")
	enemy.velocity.y = enemy.jumpVelocity
	enemy.velocity.x = 0
	
func onPhysicsProcess(delta):
	
	applyGravity(delta)
	enemy.move_and_slide()
	
	if enemy.velocity.y >= 0:
		stateMachine.changeState("fall")

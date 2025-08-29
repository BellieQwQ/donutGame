extends EnemyState

func enterState():
	enemy.animator.play("idle")   

func onPhysicsProcess(delta):
	enemy.velocity.x = move_toward(enemy.velocity.x, 0, enemy.DECELERATION * delta)   
	
	if enemy.player and enemy.player.velocity.y < 0 and enemy.is_on_floor():
		stateMachine.changeState("Jump")
		return
	
	applyGravity(delta)                       
	enemy.move_and_slide()   

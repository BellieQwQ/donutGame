extends State

func enterState():
	player.animator.play("Fall")
	print("Entering state: " + str(stateMachine.currentState))

func onPhysicsProcess(delta):
	getDirection()
	player.isSprinting = Input.is_action_pressed("Sprint")
	flip()
	
	if handleJumpEvents(delta):
		return
	
	if player.direction != 0:
		var targetSpeed = (player.SPRINT_SPEED if player.isSprinting else player.SPEED) * player.direction
		player.velocity.x = move_toward(player.velocity.x, targetSpeed, player.ACCELERATION * delta)
	
	applyGravity(delta)
	
	if player.is_on_floor():
		stateMachine.changeState("Idle")
	
	handlePlayerCorrection(delta)

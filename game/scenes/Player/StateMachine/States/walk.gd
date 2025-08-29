extends State

func enterState():
	player.animator.play("Walk")
	print("Entering state: " + str(stateMachine.currentState))
	
func onPhysicsProcess(delta):
	if handleJumpEvents(delta):
		return
	
	if !player.is_on_floor() and player.velocity.y > 0:
		stateMachine.changeState("Fall")
		return
	
	if Input.is_action_pressed("Down"):
		stateMachine.changeState("Crouch")
		return
	
	getDirection()
	
	if Input.is_action_pressed("Sprint") and player.direction != 0:
		stateMachine.changeState("Sprint")
		return
	
	var targetSpeed = player.SPEED * player.direction
	
	if player.direction != 0:
		if player.is_on_floor():
			player.velocity.x = move_toward(player.velocity.x, targetSpeed, player.ACCELERATION * delta)
	else:
		if player.is_on_floor():
			player.velocity.x = move_toward(player.velocity.x, targetSpeed, player.DECELERATION * delta)
			if abs(player.velocity.x) < 1:
				stateMachine.changeState("Idle")
	
	flip()
	applyGravity(delta)
	handlePlayerCorrection(delta)

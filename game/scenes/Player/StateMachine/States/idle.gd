extends State

func enterState():
	player.animator.play("Idle")
	print("Entering state: " + str(stateMachine.currentState))
	
func onPhysicsProcess(delta):
	
	if handleJumpEvents(delta):
		return
	
	if !player.is_on_floor() and player.velocity.y > 0:
		stateMachine.changeState("Fall")
		return
	
	getDirection()
	
	applyGravity(delta)
	handlePlayerCorrection(delta)
	
	if player.is_on_floor():
		player.velocity.x = move_toward(player.velocity.x, 0, player.DECELERATION * delta)
	
	if player.direction != 0:
		if Input.is_action_pressed("Sprint"):
			stateMachine.changeState("Sprint")
		else:
			stateMachine.changeState("Walk")
	
	if Input.is_action_pressed("Down"):
		stateMachine.changeState("Crouch")
	
	

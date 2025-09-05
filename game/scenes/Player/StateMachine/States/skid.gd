extends State

func enterState():
	player.animator.play("Skidding")
	print("Entering state: " + str(stateMachine.currentState))
	
func onPhysicsProcess(delta):
	if handleJumpEvents(delta):
		return
	
	if !player.is_on_floor() and player.velocity.y > 0:
		stateMachine.changeState("Fall")
		return
	
	getDirection()
	
	player.velocity.x = move_toward(player.velocity.x, 0, player.SKID_DECELERATION * delta)
	
	if player.is_on_floor() and abs(player.velocity.x) < 100:
		if player.direction != 0:
			if Input.is_action_pressed("Sprint"):
				stateMachine.changeState("Sprint")
			else:
				stateMachine.changeState("Walk")
		return
	
	flip()
	applyGravity(delta)
	handlePlayerCorrection(delta)

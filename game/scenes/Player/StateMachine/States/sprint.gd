extends State

func enterState():
	player.animator.play("Run")
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
	
	if Input.is_action_just_pressed("Slide") and player.is_on_floor() and abs(player.velocity.x) >= 800 and player.slideCooldown.is_stopped():
		stateMachine.changeState("Slide")
		return
	
	getDirection()
	
	if !Input.is_action_pressed("Sprint") or player.direction == 0:
		if player.direction != 0:
			stateMachine.changeState("Walk")
		else:
			stateMachine.changeState("Idle")
	
	var targetSpeed = player.SPRINT_SPEED * player.direction
	player.velocity.x = move_toward(player.velocity.x, targetSpeed, player.ACCELERATION * delta)
	
	if sign(player.direction) != sign(player.velocity.x) and player.direction != 0 and abs(player.velocity.x) > player.SKID_THRESHOLD:
		stateMachine.changeState("Skid")
		return
		
	flip()
	applyGravity(delta)
	handlePlayerCorrection(delta)
	

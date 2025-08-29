extends State

func enterState():
	player.animator.play("Jump")
	player.velocity.y = player.jumpVelocity
	print("Entering state: " + str(stateMachine.currentState))
	
	player.standingCollision.disabled = true
	player.jumpingCollision.disabled = false
	
func onPhysicsProcess(delta):
	applyGravity(delta)
	getDirection()
	player.isSprinting = Input.is_action_pressed("Sprint")
	flip()
	
	player.coyoteTimer -= delta
	player.jumpBufferTimer -= delta
	
	if player.direction != 0:
		var target_speed = (player.SPRINT_SPEED if player.isSprinting else player.SPEED) * player.direction
		player.velocity.x = move_toward(player.velocity.x, target_speed, player.ACCELERATION * delta)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.DECELERATION * delta)
	
	
	if player.velocity.y < 0 and !Input.is_action_pressed("Up"):
		player.velocity.y *= 0.8
	
	if player.velocity.y >= 0:
		stateMachine.changeState("Fall")
	
	handlePlayerCorrection(delta)
	
func exitState():
	player.standingCollision.disabled = false
	player.jumpingCollision.disabled = true

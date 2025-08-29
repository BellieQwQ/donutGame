extends State

func enterState():
	player.animator.play("Slide")
	print("Entering state: " + str(stateMachine.currentState))
	
	player.slideDirection = sign(player.velocity.x)
	player.velocity.x = player.slideDirection * player.SLIDE_SPEED
	player.slideDuration.start()
	
	player.standingCollision.disabled = true
	player.slidingCollision.disabled = false
	
func onPhysicsProcess(delta):
	player.velocity.x = move_toward(player.velocity.x, 0, player.SLIDE_DECELERATION * delta)
	
	if handleJumpEvents(delta):
		return
	
	if !player.is_on_floor() and player.velocity.y > 0:
		stateMachine.changeState("Fall")
		return
	
	applyGravity(delta)
	handlePlayerCorrection(delta)
	
func _on_slide_duration_timeout():
	if stateMachine.currentState != self:
		return
	player.slideCooldown.start()
	stateMachine.changeState("Idle")
	
func exitState():
	if player.slideDuration.is_stopped() == false:
		player.slideDuration.stop()
	
	player.standingCollision.disabled = false
	player.slidingCollision.disabled = true

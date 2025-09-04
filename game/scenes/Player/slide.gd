extends State

func enterState():
	player.animator.play("Slide")
	print("Entering state: " + str(stateMachine.currentState))
	
	player.slideDirection = sign(player.velocity.x)
	player.velocity.x = player.slideDirection * player.SLIDE_SPEED
	player.slideDuration.start()
	
	player.standingCollision.set_deferred("disabled", true)
	player.slideDetector.set_deferred("enabled", true)
	player.slidingCollision.set_deferred("disabled", false)
	
func onPhysicsProcess(delta):
	var blockedAbove = player.slideDetector.is_colliding()
	
	if !blockedAbove:
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
	
	if player.slideDetector.is_colliding():
		player.slideDuration.start()
	else:
		player.slideCooldown.start()
		stateMachine.changeState("Idle")
	
func exitState():
	if player.slideDuration.is_stopped() == false:
		player.slideDuration.stop()
	
	player.standingCollision.set_deferred("disabled", false)
	player.slideDetector.set_deferred("enabled", false)
	player.slidingCollision.set_deferred("disabled", true)

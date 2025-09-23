extends State

var newPunch: Node

func enterState():
	player.animator.play("Slide")
	print("Entering state: " + str(stateMachine.currentState))
	
	player.slideDirection = sign(player.velocity.x)
	player.velocity.x = player.slideDirection * player.SLIDE_SPEED
	player.slideDuration.start()
	
	player.standingCollision.set_deferred("disabled", true)
	player.slideDetector.set_deferred("enabled", true)
	player.slidingCollision.set_deferred("disabled", false)
	
	newPunch = player.punchScene.instantiate()
	player.add_child(newPunch)
	newPunch.global_position = player.slideMarker.global_position
	
	var area: Area2D = null
	if newPunch is Area2D:
		area = newPunch
	else:
		area = newPunch.get_node_or_null("Area2D")
	
	if area:
		area.area_entered.connect(player._on_punch_area_entered)
	
func onPhysicsProcess(delta):
	var blockedAbove = player.slideDetector.is_colliding()
	
	if !blockedAbove:
		player.velocity.x = move_toward(player.velocity.x, 0, player.SLIDE_DECELERATION * delta)
	
	if handleJumpEvents(delta):
		return
	
	if !player.is_on_floor() and player.velocity.y > 0:
		stateMachine.changeState("Fall")
		return
	
	if player.is_on_wall():
		player.velocity.x = (player.slideDirection * -1) * player.knockbackForce
		
		player.velocity.y = player.knockbackHeight
		stateMachine.changeState("Jump")
	
	applyGravity(delta)
	handlePlayerCorrection(delta)
	
func _on_slide_duration_timeout():
	if stateMachine.currentState != self:
		return
	
	if player.blockedAbove:
		player.slideDuration.start()
	else:
		player.slideCooldown.start()
		stateMachine.changeState("Idle")
	
func exitState():
	if player.slideDuration.is_stopped() == false:
		player.slideDuration.stop()
		
	if newPunch and is_instance_valid(newPunch):
		newPunch.queue_free()
		newPunch = null
	
	player.standingCollision.set_deferred("disabled", false)
	player.slideDetector.set_deferred("enabled", false)
	player.slidingCollision.set_deferred("disabled", true)

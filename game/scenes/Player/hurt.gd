extends State

func enterState():
	player.animator.play("Crouch")
	player.FXmanager.play("Iframes")
	player.invincibleTime.start()
	player.knockTime.start()
	player.invincible = true
	player.velocity.y = player.knockbackHeight
	
	if player.knockbackDirection > 0:
		player.velocity.x = player.knockbackForce
	else:
		player.velocity.x = -player.knockbackForce
	
	print("Entering state: " + str(stateMachine.currentState))
	
func onPhysicsProcess(delta):
	if player.is_on_floor():
		player.velocity.x = move_toward(player.velocity.x, 0, player.DECELERATION * delta)
	
	getDirection()
	
	applyGravity(delta)
	handlePlayerCorrection(delta)
	
func _on_iframes_timeout():
	player.invincible = false
	
	var hurtboxes = get_tree().get_nodes_in_group("hitbox")
	for hurtbox in hurtboxes:
		if hurtbox is Area2D:
			hurtbox.monitoring = false
	await get_tree().process_frame
	for hurtbox in hurtboxes:
		if hurtbox is Area2D:
			hurtbox.monitoring = true
	
	
func _on_knock_time_timeout():
	stateMachine.changeState("Idle")

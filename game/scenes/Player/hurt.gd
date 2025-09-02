extends State

func enterState():
	player.animator.play("Crouch")
	player.FXmanager.play("Iframes")
	player.lives -= 1
	player.invincibleTime.start()
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
	stateMachine.changeState("Idle")
	player.invincible = false

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
	getDirection()
	
	applyGravity(delta)
	handlePlayerCorrection(delta)
	
func _on_iframes_timeout():
	player.invincible = false
	
func _on_knock_time_timeout():
	stateMachine.changeState("Idle")

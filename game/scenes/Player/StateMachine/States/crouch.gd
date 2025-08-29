extends State

func enterState():
	player.animator.play("Crouching")
	print("Entering state: " + str(stateMachine.currentState))
	
	if not player.animator.animation_finished.is_connected(_on_anim_finished):
		player.animator.animation_finished.connect(_on_anim_finished)
	
	player.standingCollision.disabled = true
	player.crouchingCollision.disabled = false
	
func onPhysicsProcess(delta):
	getDirection()
	
	if (player.is_on_floor() or player.coyoteTimer > 0) and Input.is_action_just_pressed("Up"):
		stateMachine.changeState("Jump")
		player.coyoteTimer = 0
		return
	
	if Input.is_action_just_released("Down"):
		if player.direction != 0:
			if Input.is_action_pressed("Sprint"):
				stateMachine.changeState("Sprint")
			else:
				stateMachine.changeState("Walk")
		else:
			stateMachine.changeState("Idle")
		return
	
	if player.is_on_floor():
			player.velocity.x = move_toward(player.velocity.x, 0, player.ACCELERATION * delta)
	
	flip()
	applyGravity(delta)
	handlePlayerCorrection(delta)
	
func _on_anim_finished():
	if stateMachine.currentState != self:
		return
	
	if player.animator.animation == "Crouching":
		player.animator.play("Crouch")
	
func exitState():
	if player.animator.animation_finished.is_connected(_on_anim_finished):
		player.animator.animation_finished.disconnect(_on_anim_finished)
	
	player.standingCollision.disabled = false
	player.crouchingCollision.disabled = true

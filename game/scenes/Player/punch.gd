extends State

var newPunch: Node 

func enterState():
	player.punchTimer.start()
	player.animator.play("Punch")
	
	newPunch = player.punchScene.instantiate()
	player.add_child(newPunch)
	newPunch.global_position = player.punchMarker.global_position
	
	print("Entering state: " + str(stateMachine.currentState))
	
func onPhysicsProcess(delta):
	getDirection()
	
	applyGravity(delta)
	handlePlayerCorrection(delta)
	
	if player.is_on_floor():
		player.velocity.x = move_toward(player.velocity.x, 0, player.DECELERATION * 0.2 * delta)
	
func _on_punch_timer_timeout():
	stateMachine.changeState("Idle")
	
func exitState():
	if newPunch and is_instance_valid(newPunch):
		newPunch.queue_free()
		newPunch = null
	

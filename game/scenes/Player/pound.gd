extends State

var newPunch: Node 

var timeOnAir = 0.15

func enterState():
	timeOnAir = 0.15
	player.animator.play("Crouch") # change to pound eventually

	
	newPunch = player.punchScene.instantiate()
	player.add_child(newPunch)
	newPunch.global_position = player.poundMarker.global_position
	
	print("Entering state: " + str(stateMachine.currentState))
	
func onPhysicsProcess(delta):
	getDirection()
	
	timeOnAir -= delta
	if timeOnAir > 0:
		player.velocity.y = 0
		player.velocity.x = 0
	else:
		applyGravity(delta)
		handlePlayerCorrection(delta)
	
	if player.is_on_floor():
		stateMachine.changeState("Idle")
		
func exitState():
	if newPunch and is_instance_valid(newPunch):
		newPunch.queue_free()
		newPunch = null
	

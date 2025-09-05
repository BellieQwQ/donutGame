class_name State
extends Node
	
var stateMachine: StateMachine
var player: Player
	
#region player functions
	
func getDirection():
	player.direction = Input.get_axis("Left", "Right")
	return player.direction
	
func flip():
	if player.direction != 0 and ((player.isFacingRight and player.direction < 0) or (!player.isFacingRight and player.direction > 0)):
		player.scale.x *= -1
		player.isFacingRight = !player.isFacingRight
	
func applyGravity(delta):
	if player.velocity.y < 0:
		player.velocity.y += player.jumpGravity * delta
	else:
		player.velocity.y += player.fallGravity * delta
	
func handleJumpEvents(delta):
	player.jumpBufferTimer -= delta
	player.coyoteTimer -= delta
	
	if Input.is_action_just_pressed("Up"):
		player.jumpBufferTimer = player.jumpBufferTime
	
	if player.is_on_floor():
		player.coyoteTimer = player.coyoteTime
	
	if (player.is_on_floor() or player.coyoteTimer > 0) and player.jumpBufferTimer > 0:
		player.coyoteTimer = 0
		player.jumpBufferTimer = 0
		stateMachine.changeState("Jump")
		return true
	return false
	
func handlePlayerCorrection(delta):
	player.applyCornerCorrection()
	player.move_and_slide()
	
#endregion
	
#region inherited state functions
	
func enterState():
	pass
	
func exitState():
	pass
	
func onProcess(delta):
	pass
	
func onPhysicsProcess(delta):
	pass
	
func handleInput(event):
	pass
	
#endregion

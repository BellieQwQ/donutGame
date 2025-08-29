class_name EnemyState
extends Node
	
var stateMachine: EnemyStateMachine
var enemy: Enemy
	
#region enemy functions
	
func flip():
	if enemy.direction != 0 and ((enemy.isMovingLeft and enemy.direction > 0) or (!enemy.isMovingLeft and enemy.direction < 0)):
		enemy.scale.x *= -1
		enemy.isMovingLeft = !enemy.isMovingLeft
	
func applyGravity(delta):
	if enemy.velocity.y < 0:
		enemy.velocity.y += enemy.jumpGravity * delta
	else:
		enemy.velocity.y += enemy.fallGravity * delta
	
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

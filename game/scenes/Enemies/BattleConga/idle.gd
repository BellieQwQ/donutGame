extends EnemyState

const FLIP_NODE_NAME = "FlipRoot"

var flipNode = null
var baseScale = 1.0
var facingLeft = true

func enterState():
	enemy.animator.play("idle")
	enemy.shootTimer.stop() 
	
	if flipNode == null:
		if enemy != null and enemy.has_node(FLIP_NODE_NAME):
			flipNode = enemy.get_node(FLIP_NODE_NAME)
	
func onPhysicsProcess(delta):
	if enemy.player == null:
		print("No player in scene")
	else:
		faceToPlayer()
	
	if !enemy.is_on_floor() and enemy.velocity.y > 0: 
		stateMachine.changeState("Fall") 
		return 
	
	if enemy.playerDetector.is_colliding(): 
		stateMachine.changeState("Move")
		return
	
	enemy.velocity.x = move_toward(enemy.velocity.x, 0, enemy.DECELERATION * delta)
	applyGravity(delta)
	enemy.move_and_slide()
	
func faceToPlayer():
	var directionX = enemy.player.global_position.x - enemy.global_position.x
	if abs(directionX) < 0.01:
		return
	
	var wantsLeft = directionX < 0
	if wantsLeft == facingLeft:
		return
	facingLeft = wantsLeft
	enemy.facingLeft = wantsLeft
	
	var newScale = flipNode.scale
	if facingLeft:
		newScale.x = baseScale
	else:
		newScale.x = -baseScale
	flipNode.scale = newScale

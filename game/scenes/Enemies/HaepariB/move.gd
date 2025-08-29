extends EnemyState

func enterState():
	enemy.animator.play("idle")
	
func onPhysicsProcess(delta):
	
	if !enemy.floorDetector.is_colliding() and !(enemy.velocity.y > 0 or enemy.velocity.y < 0):
		enemy.direction *= -1
		flip()
	
	if enemy.is_on_wall():
		enemy.direction *= -1
		flip()
	
	if enemy.is_on_floor():
		enemy.velocity.x = enemy.SPEED * enemy.direction
	
	applyGravity(delta)
	enemy.move_and_slide()

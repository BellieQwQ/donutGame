extends EnemyState

func enterState():
	enemy.animator.play("Idle")
	
	
func onPhysicsProcess(_delta):
	pass

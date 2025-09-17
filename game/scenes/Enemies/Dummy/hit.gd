extends EnemyState


func enterState():
	enemy.animator.play("Hit")
	enemy.FX.play("Hit")
	
func onPhysicsProcess(_delta):
	pass
	
func _on_animated_sprite_2d_animation_finished() -> void:
	enemy.stateMachine.changeState("Idle")

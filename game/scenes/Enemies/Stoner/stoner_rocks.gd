extends RigidBody2D

func _on_hurtbox_body_entered(body):
	if body.is_in_group("player"):
		queue_free()

func _on_rock_lifetime_timeout():
	queue_free()

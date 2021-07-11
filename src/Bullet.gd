extends RigidBody2D

var is_hit = false

func _ready():
	set_as_toplevel(true)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Bullet_body_entered(_body):
	if !is_hit:
		is_hit = true
		$Boom.play()


func _on_Boom_finished():
	queue_free()

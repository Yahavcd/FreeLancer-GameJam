extends RigidBody2D

func _ready():
	set_as_toplevel(true)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Bullet_body_entered(_body):
	queue_free()

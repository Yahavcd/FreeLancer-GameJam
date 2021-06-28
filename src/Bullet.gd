extends Node2D


func _ready():
	set_as_toplevel(true)

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

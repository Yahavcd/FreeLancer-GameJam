extends Area2D

func _process(_delta):
	if gamestate.is_dead == false:
		look_at(get_global_mouse_position())

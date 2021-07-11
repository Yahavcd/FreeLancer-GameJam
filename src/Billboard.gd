extends Area2D

func _process(_delta):
	if $RayCast2D.is_colliding():
		if Input.is_action_pressed("Start"):
			get_tree().change_scene("res://Scenes/Items/MissionStore.tscn")

func _on_MenuButton_pressed():
	get_tree().change_scene("res://Scenes/Items/MissionStore.tscn")

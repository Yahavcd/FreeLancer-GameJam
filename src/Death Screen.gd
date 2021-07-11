extends Control

func _on_Button_button_up():
	gamestate.shots = gamestate.maxShots
	gamestate.lives = gamestate.maxlives
	gamestate.shots = gamestate.maxShots
	gamestate.color = Color(1,1,1,1)
	gamestate.is_dead = false
	gamestate.count_bird = 0
	gamestate.count_goblin = 0
	gamestate.count_boss = 0
	gamestate.count_slime = 0
	get_tree().change_scene("res://Scenes/Levels/Hub.tscn")

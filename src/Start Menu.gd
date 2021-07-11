extends Control

func _on_Start_button_up():
	get_tree().change_scene("res://Scenes/Levels/Hub.tscn")

func _on_Exit_button_down():
	get_tree().quit()

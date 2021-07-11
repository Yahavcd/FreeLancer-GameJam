extends Node2D

var difficulty = 1
var Plains_difficulty
var Cave_difficulty
var Platforms_difficulty
var UI = preload("res://Scenes/UI/UI.tscn")

func _ready():
	difficulty = difficulty + gamestate.mission_count/3
	if difficulty > 7:
		difficulty = 7
	randomize()
	
	Plains_difficulty = (randi() % difficulty + 1)
	Cave_difficulty = (randi() % difficulty + 1)
	Platforms_difficulty = (randi() % difficulty + 1)
	
	if Plains_difficulty <= 2:
		$Jobs/Plains/Label.text += "Easy"
	elif Plains_difficulty <= 4:
		$Jobs/Plains/Label.text += "Medium"
	else:
		$Jobs/Plains/Label.text += "Hard"
	
	if Cave_difficulty <= 2:
		$Jobs/Cave/Label.text += "Easy"
	elif Cave_difficulty <= 4:
		$Jobs/Cave/Label.text += "Medium"
	else:
		$Jobs/Cave/Label.text += "Hard"
		
	if Platforms_difficulty <= 2:
		$Jobs/Platforms/Label.text += "Easy"
	elif Platforms_difficulty <= 4:
		$Jobs/Platforms/Label.text += "Medium"
	else:
		$Jobs/Platforms/Label.text += "Hard"


func _on_Jobs_pressed():
	$Menus.hide()
	$Jobs.show()


func _on_Store_pressed():
	$Menus.hide()
	$Store.show()


func _on_Plains_pressed():
	gamestate.difficulty = Plains_difficulty
	get_tree().change_scene("res://Scenes/Levels/Level1.tscn")


func _on_Cave_pressed():
	gamestate.difficulty = Cave_difficulty
	get_tree().change_scene("res://Scenes/Levels/Level2.tscn")


func _on_Platforms_pressed():
	gamestate.difficulty = Platforms_difficulty
	get_tree().change_scene("res://Scenes/Levels/Level3.tscn")


func _on_Back_pressed():
	$Menus.show()
	$Jobs.hide()


func _on_Life_pressed():
	if gamestate.maxlives < gamestate.limitLives:
		if gamestate.money >= 10000:
			gamestate.money -= 10000
			gamestate.maxlives += 1
			gamestate.lives = gamestate.maxlives
			$UI.queue_free()
			self.add_child(UI.instance())
			


func _on_Bullets_pressed():
	if gamestate.maxShots < gamestate.limitShots:
		if gamestate.money >= 7500:
			gamestate.money -= 7500
			gamestate.maxShots += 1
			gamestate.shots = gamestate.maxShots
			$UI.queue_free()
			self.add_child(UI.instance())

func _on_Back_button_down():
	$Menus.show()
	$Store.hide()


func _on_Exit_pressed():
	get_tree().quit()

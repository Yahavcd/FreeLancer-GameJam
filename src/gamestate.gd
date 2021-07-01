extends Node

# Global player Variables:
var maxShots = 3
var maxlives = 3
var lives = 3
var shots = maxShots
var color = Color(1,1,1,1)
var reloadAnimTime = 2.3
var is_dead = false

func _ready():
	randomize()

func _process(_delta):
	if Input.is_action_pressed("exit"):
		get_tree().quit() 

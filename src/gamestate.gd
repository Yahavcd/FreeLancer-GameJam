extends Node

# Global player Variables:
var maxShots = 3
var maxlives = 3
var lives = 3
var shots = maxShots
var color = Color(1,1,1,1)
var reloadAnimTime = 1
var is_dead = false

var difficulty = [1,2,3,4,5,6,7]

func _ready():
	reloadAnimTime = float(maxShots)/3
	randomize()

func _process(_delta):
	if Input.is_action_pressed("exit"):
		get_tree().quit() 

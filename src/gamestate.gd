extends Node

# Global player Variables:
var maxShots = 3
const limitShots = 7
var maxlives = 3
const limitLives = 5
var money = 0
const limitMoney = 99999
var lives = 3
var shots = maxShots
var color = Color(1,1,1,1)
var reloadAnimTime = 1
var is_dead = false
var mission_count = 0
var difficulty = 1

var count_goblin = 0
var count_bird = 0
var count_slime = 0
var count_boss = 0


func _ready():
	reloadAnimTime = float(maxShots)/3
	randomize()

func _process(_delta):
	if Input.is_action_pressed("exit"):
		get_tree().quit() 

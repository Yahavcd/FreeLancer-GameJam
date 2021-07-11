extends Control

var money = 0
var UI_money = preload("res://Scenes/Items/Money.tscn")
var UI = preload("res://Scenes/Items/points.tscn")
var boss = preload("res://Assets/Enemies/Minotaor/Idle/minoaxe_0004_IDEL1.png")
var slime = preload("res://Assets/Enemies/Slime/Slime.png")
var bird = preload("res://Assets/Enemies/Harpy/Harpy.png")
var goblin = preload("res://Assets/Enemies/Goblin/Goblin.png")

var enemies = ["0","0","0","0"]
var enemies_num = ["0","0","0","0"]
var count = 0

func _ready():

	if gamestate.count_goblin > 0:
		get_node("VBoxContainer").add_child(UI.instance())
		count += 1
		enemies[count - 1] = "goblin"
	if gamestate.count_bird > 0:
		get_node("VBoxContainer").add_child(UI.instance())
		count += 1
		enemies[count - 1] = "bird"
	if gamestate.count_slime > 0:
		get_node("VBoxContainer").add_child(UI.instance())
		count += 1
		enemies[count - 1] = "slime"
	if gamestate.count_boss > 0:
		get_node("VBoxContainer").add_child(UI.instance())
		count += 1
		enemies[count - 1] = "boss"
	count = 0
	
	for _i in get_node("VBoxContainer").get_children():
		_i.set_name("TextureRect" + enemies[count])
		count+=1
		
	if get_node("VBoxContainer/TextureRectgoblin/Label") != null:
		get_node("VBoxContainer/TextureRectgoblin/Label").text += String(gamestate.count_goblin)
		get_node("VBoxContainer/TextureRectgoblin/TextureRect").set_texture(goblin)
	if get_node("VBoxContainer/TextureRectbird/Label") != null:
		get_node("VBoxContainer/TextureRectbird/Label").text += String(gamestate.count_bird)
		get_node("VBoxContainer/TextureRectbird/TextureRect").set_texture(bird)
	if get_node("VBoxContainer/TextureRectslime/Label") != null:
		get_node("VBoxContainer/TextureRectslime/Label").text += String(gamestate.count_slime)
		get_node("VBoxContainer/TextureRectslime/TextureRect").set_texture(slime)
	if get_node("VBoxContainer/TextureRectboss/Label") != null:
		get_node("VBoxContainer/TextureRectboss/Label").text += String(gamestate.count_boss)
		get_node("VBoxContainer/TextureRectboss/TextureRect").set_texture(boss)
	
	money = gamestate.count_boss *500 + gamestate.count_slime * 50 + gamestate.count_bird * 100 +gamestate.count_goblin * 25
	
	get_node("VBoxContainer").add_child(UI_money.instance())
	get_node("VBoxContainer/Money/Label").text = String(money)
	

func _on_Exit_pressed():
	gamestate.shots = gamestate.maxShots
	gamestate.lives = gamestate.maxlives
	gamestate.shots = gamestate.maxShots
	gamestate.money = money
	gamestate.is_dead = false
	gamestate.color = Color(1,1,1,1)
	gamestate.count_bird = 0
	gamestate.count_goblin = 0
	gamestate.count_boss = 0
	gamestate.count_slime = 0
	get_tree().change_scene("res://Scenes/Levels/Hub.tscn")


extends CanvasLayer

var live
var shots

func _ready():
	live = gamestate.lives 
	shots = gamestate.shots
	
func ammo():
	if shots > gamestate.shots:
		get_node("Control/VBoxContainer/BulletBar/HBoxContainer/TextureRect"+String(shots)).hide()
		shots = gamestate.shots

func lives():
	if live > gamestate.lives:
		get_node("Control/VBoxContainer/LifeBar/HBoxContainer/TextureRect"+String(live)).hide()
		live = gamestate.lives

func reload():
	var count = 0
	while (count < gamestate.maxShots):
		count += 1
		get_node("Control/VBoxContainer/BulletBar/HBoxContainer/TextureRect"+String(count)).show()
		print(count)
	shots = gamestate.maxShots

func _on_Player_hit():
	lives()


func _on_Player_reload():
	reload()


func _on_Player_shot():
	ammo()

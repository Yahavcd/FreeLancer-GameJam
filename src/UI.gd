extends CanvasLayer

var live
var shots
var money

func _ready():
	var count = 1
	live = gamestate.maxlives 
	shots = gamestate.maxShots
	money = gamestate.money
	if self.get_parent().name == "Hub" or self.get_parent().name == "MissionStore":
		$Control/VBoxContainer2.show()
	else:
		$Control/VBoxContainer2.hide()
	while(count < gamestate.maxlives):
		get_node("Control/VBoxContainer/LifeBar/HBoxContainer").add_child(get_node("Control/VBoxContainer/LifeBar/HBoxContainer/TextureRect1").duplicate(8))
		count += 1
	count = 1
	while(count < gamestate.maxShots):
		get_node("Control/VBoxContainer/BulletBar/HBoxContainer").add_child(get_node("Control/VBoxContainer/BulletBar/HBoxContainer/TextureRect1").duplicate(8))
		count += 1
	
	count = 1
	for _i in get_node("Control/VBoxContainer/LifeBar/HBoxContainer").get_children():
		_i.set_name("TextureRect" + String(count))
		count += 1
		
	count = 1
	for _i in get_node("Control/VBoxContainer/BulletBar/HBoxContainer").get_children():
		_i.set_name("TextureRect" + String(count))
		count += 1
		
	ammo()
	lives()
	moneyCount()
	
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
	shots = gamestate.maxShots
	
func moneyCount():
	$Control/VBoxContainer2/HBoxContainer/MoneyBar/Label.text = String(money)

func _on_Player_hit():
	lives()

func _on_Player_reload():
	reload()

func _on_Player_shot():
	ammo()

func _on_MissionStore_update_UI():
	live = gamestate.maxlives 
	shots = gamestate.maxShots
	money = gamestate.money
	lives()
	moneyCount()

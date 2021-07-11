extends KinematicBody2D

export var speed = 120
export var in_air_speed = 2
export var bullet_speed = 500
export var gravity = 400
export var max_jump_speed = 200
export var hit_velocity = 100
export (float, 0, 1.0) var friction = 1
export (float, 0, 1.0) var acceleration = 0.25
export var invinceble_duarion = 2

signal hit
signal shot
signal reload
signal is_reloading
var lastcolor
var velocity = Vector2.ZERO
var nextShotAnimTime = 0.1
var tween_ready = true
var is_hit = false
var bullet = preload("res://Scenes/Items/Bullet.tscn")
var lanceCollision
var current_pos

#Get information on players status form the gamestate
func _ready():
	$LancePivot/Lance.modulate = gamestate.color
	lanceCollision = $LancePivot/LanceHitBox
	
#Physics process for input and movment
func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	if (velocity.y > 700) and not gamestate.is_dead:
		global_position = current_pos
		hit(0)
		#need area2d world limit

#Process input into movment and actions
func get_input():
	var dir = 0
	if is_on_floor():	
		if Input.is_action_pressed("Right") and not is_hit:
			animation_sprite("walk",false)
			dir += 1
		if Input.is_action_pressed("Left") and not is_hit:
			animation_sprite("walk",false)
			dir -= 1
		if dir != 0:
			velocity.x = lerp(velocity.x, dir * speed, acceleration)
		else:
			velocity.x = lerp(velocity.x, 0, friction)
			if not is_hit:
				animation_sprite("idle",false)
	else:
		if not is_hit:
			jump_animation()
			if Input.is_action_pressed("Right"):
				dir += 1
			if Input.is_action_pressed("Left"):
				dir -= 1
			if dir != 0:
				velocity.x += dir * in_air_speed
		else:
			velocity.x = lerp(velocity.x, 0, friction)
	
	if $HurtBox.is_invinceble == false:	
		lanceCollision.set_deferred("disabled", false)
		if Input.is_action_just_pressed("Action") and tween_ready:
			if gamestate.shots > 0:
				tween_cooldown("stop")
				fire()
				tween_overheat("shot")
				animation_player("GunAttack")
				jump()

#Calculate the jump and slide trajectory after firing
func jump():
	var lance = $LancePivot

	velocity.y = cos(deg2rad(lance.rotation_degrees+90)) * max_jump_speed
	velocity.x = -sin(deg2rad(lance.rotation_degrees+90)) * max_jump_speed

#Instance a bullet after firing
func fire():
	var lance = $LancePivot
	var gunlance = $LancePivot/Lance/GunLance	
	var bullet_instance = bullet.instance()
	$Shot.play()
	
	gamestate.shots -= 1
	emit_signal("shot")
	bullet_instance.position = gunlance.global_position
	bullet_instance.rotation_degrees = lance.rotation_degrees
	bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed,0).rotated(lance.rotation))
	gunlance.add_child(bullet_instance)

#Handle the jump sprite based on the character movment up or down
func jump_animation():
	if velocity.y > 0:
		animation_sprite("jumpDown",false)
	elif velocity.y < 0:
		animation_sprite("jumpUp",false)

#Handle the animated sprite animations
func animation_sprite(animationSprite,reverse):
	$PlayerBody.play(animationSprite,reverse)

#Handle the animation player animations
func animation_player(animationPlayer):
	$AnimationPlayer.play(animationPlayer)

#Handle the tween overheat animations
func tween_overheat(tweenAnimation):
	var OverHeat = $LancePivot/Lance/OverHeat
	
	if tweenAnimation == "shot":
		lastcolor = $LancePivot/Lance.modulate
		OverHeat.interpolate_property($LancePivot/Lance, "modulate", lastcolor, gamestate.color - Color(0,0.15,0.15,0), nextShotAnimTime, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		OverHeat.start()
		tween_ready = false

#Handle the tween cooldown animations
func tween_cooldown(tweenAnimation):
	var CoolDown = $LancePivot/Lance/CoolDown
	
	if tweenAnimation == "stop":
		CoolDown.remove_all()
		
	if tweenAnimation == "cooldown":
		emit_signal("is_reloading", calc_reloadtime())
		CoolDown.interpolate_property($LancePivot/Lance, "modulate", gamestate.color, Color(1,1,1,1), calc_reloadtime(), Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		CoolDown.start()
		$reload.play()
	
#Calculate reload time
func calc_reloadtime():
	var calcReloadtime
	calcReloadtime = gamestate.reloadAnimTime - 0.25 * (float(gamestate.shots)/gamestate.maxShots)
	return calcReloadtime

#Handle the hit sequance
func hit(direction):
	var timer = $HitDuration
	
	$Blinker.start_blinking(self, invinceble_duarion)
	$HurtBox.start_invincebility(invinceble_duarion)
	
	lanceCollision.set_deferred("disabled", true)
	gamestate.lives -= 1
	emit_signal("hit")
	is_hit = true
	if gamestate.lives == 0:
		tween_cooldown("stop")
		death()
	if gamestate.is_dead == false:
		$HurtBox.is_invinceble = true
		timer.start()
		animation_sprite("hit",false)
	
	velocity.y = -hit_velocity
	if direction == 0:
			velocity = Vector2.ZERO
	elif direction > 0:
		velocity.x = hit_velocity
	else:
		velocity.x = -hit_velocity

#Handle the death sequance
func death():		
	gamestate.is_dead = true
	$HurtBox.is_dead = true
	animation_sprite("death",false)
	$deathTimer.start()

#Signal the end of all tween animations
func _on_OverHeat_tween_all_completed():
	tween_ready = true
	gamestate.color = $LancePivot/Lance.modulate
	tween_cooldown("cooldown")

#Signal the end of the cooldown tween animation
func _on_CoolDown_tween_all_completed():
	emit_signal("reload")
	tween_ready = true
	gamestate.color = $LancePivot/Lance.modulate
	gamestate.shots = gamestate.maxShots

#Signal the end of death timer
func _on_deathTimer_timeout():
	gamestate.is_dead = false
	get_tree().change_scene("res://Scenes/Screen/Death Screen.tscn")

func _on_HurtBox_area_entered(area):
	if (area.name == "HitBox" or area.name == "Attack") and not is_hit:
		hit(self.global_position.x - area.global_position.x)
	   
func _on_HitDuration_timeout():
	is_hit = false

func _on_LastPosition_timeout():
	if is_on_floor():
		current_pos = global_position

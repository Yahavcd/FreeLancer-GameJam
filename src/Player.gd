extends KinematicBody2D

export var speed = 150
export var bullet_speed = 500
export var gravity = 400
export var max_jump_speed = 300
export var hit_velocity = 100
export (float, 0, 1.0) var friction = 0.75
export (float, 0, 1.0) var acceleration = 0.25

var cooldowntime
var cooldown_timer
var lastcolor
var velocity = Vector2.ZERO
var nextShotAnimTime = 0.1
var tween_ready = true
var is_hit = false
var is_invincible = false
var bullet = preload("res://Scenes/Items/Bullet.tscn")

#Get information on players status form the gamestate
func _ready():
	cooldown_timer = $LancePivot/Lance/cooldownTimer
	$LancePivot/Lance.modulate = gamestate.color
	cooldowntime = cooldown_timer.get_wait_time()
	
#Physics process for input and movment
func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)

#Process input into movment and actions
func get_input():
	if is_on_floor():	
		var dir = 0
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
	
	if is_invincible == false:	
		if Input.is_action_just_pressed("Action") and tween_ready:
			if gamestate.shots > 0:
				tween_cooldown("stop")
				cooldown_timer.start()
				fire()
				tween_overheat("shot")
				animation_player("GunAttack")
				jump()
			else:
				tween_cooldown("stop")
				tween_overheat("reload")
	
		if Input.is_action_pressed("Reload") and tween_ready:
			tween_cooldown("stop")
			tween_overheat("reload")

#Calculate the jump and slide trajectory after firing
func jump():
	var rotation = calc_rotation_percent() * 360

	velocity.y = cos(deg2rad(rotation)) * max_jump_speed
	velocity.x = -sin(deg2rad(rotation)) * max_jump_speed
	
	if velocity.y > 200:
		velocity.y = 200
	if velocity.y < -200:
		velocity.y = -200

#Instance a bullet after firing
func fire():
	var lance = $LancePivot
	var gunlance = $LancePivot/Lance/GunLance	
	var bullet_instance = bullet.instance()
	
	gamestate.shots -= 1
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
		
	if tweenAnimation == "reload":
		gamestate.color = $LancePivot/Lance.modulate
		OverHeat.interpolate_property($LancePivot/Lance, "modulate", gamestate.color, Color(1,1,1,1), calc_reloadtime(), Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		gamestate.shots = gamestate.maxShots
		OverHeat.start()
		tween_ready = false

#Handle the tween cooldown animations
func tween_cooldown(tweenAnimation):
	var CoolDown = $LancePivot/Lance/CoolDown
	
	if tweenAnimation == "stop":
		CoolDown.remove_all()
		
	if tweenAnimation == "cooldown":
		CoolDown.interpolate_property($LancePivot/Lance, "modulate", gamestate.color, Color(1,1,1,1), cooldowntime, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		CoolDown.start()

#Normalize the lance rotation percent to be 0 - 1.0
func calc_rotation_percent():
	var lance = $LancePivot
	var rotation_percent
	var rotation_chk =int(lance.rotation_degrees/ 360)
	
	if lance.rotation_degrees > 0:
		rotation_chk = abs(lance.rotation_degrees - (rotation_chk * 360))
	else:	
		rotation_chk = (abs(rotation_chk) + 1) * 360 + lance.rotation_degrees
	
	rotation_percent = (rotation_chk+90) / 360
	if rotation_percent > 1:
		rotation_percent = rotation_percent - 1
	return rotation_percent

#Calculate reload time
func calc_reloadtime():
	var calcReloadtime
	calcReloadtime = gamestate.reloadAnimTime - (gamestate.color.g * gamestate.reloadAnimTime)
	return calcReloadtime

#Handle the hit sequance
func hit(direction):
	var hitbox = $PlayerHitBox/PlayerCollisionBox
	var timer = $PlayerBody/Invincibilityframes
	var lanceCollision = $LancePivot/LanceHitBox
	
	hitbox.set_deferred("disabled", true)
	lanceCollision.set_deferred("disabled", true)
	
	gamestate.lives -= 1
	is_hit = true
	if gamestate.lives == 0:
		gamestate.is_dead = true
		death()
	if gamestate.is_dead == false:
		is_invincible = true
		timer.start()
		animation_sprite("hit",false)
		
	animation_player("hit")
	
	velocity.y = -hit_velocity
	if direction >= 0:
		velocity.x = hit_velocity
	else:
		velocity.x = -hit_velocity

#Handle the death sequance
func death():
	animation_sprite("death",false)
	$deathTimer.start()

#Signal the end of all tween animations
func _on_OverHeat_tween_all_completed():
	tween_ready = true
	gamestate.color = $LancePivot/Lance.modulate
	tween_cooldown("cooldown")
	
#Signal the end of the cooldown timer
func _on_cooldownTimer_timeout():
	gamestate.shots = gamestate.maxShots

#Signal the end of the cooldown tween animation
func _on_CoolDown_tween_all_completed():
	gamestate.color = $LancePivot/Lance.modulate

#Signal the end of the Invincibilityframes
func _on_Invincibilityframes_timeout():
	is_hit = false

#Signal the end of the Animation Player animation
func _on_AnimationPlayer_animation_finished(anim_name):
	var hitbox = $PlayerHitBox/PlayerCollisionBox
	var lanceCollision = $LancePivot/LanceHitBox
	
	if anim_name == "hit":
		is_invincible = false
		hitbox.set_deferred("disabled", false)
		lanceCollision.set_deferred("disabled", false)
		self.set_collision_mask_bit(2, true)

#Signal enemy attack
func _on_PlayerHitBox_area_entered(area):
	if area.name == "HitBox" and not is_hit:
		hit(self.global_position.x - area.global_position.x)

#Signal the end of death timer
func _on_deathTimer_timeout():
	gamestate.is_dead = false
	get_tree().quit() 

extends KinematicBody2D

var velocity = Vector2.ZERO
export var speed = 100
export var bullet_speed = 500
export var gravity = 400
export var max_jump_speed = 200
export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.25
export var reloadAnimTime = 2
export var nextShotAnimTime = 0.5

var lance
var animation
var OverHeat
var color
var gunlance 
var tween_ready = true

var bullet = preload("res://Scenes/Items/Bullet.tscn")

func _ready():
	animation = $AnimationPlayer
	lance = $LancePivot
	OverHeat = $LancePivot/Lance/OverHeat
	color = $LancePivot/Lance.modulate
	gunlance = $LancePivot/Lance/GunLance	

func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)

func get_input():
	if is_on_floor():	
		var dir = 0
		if Input.is_action_pressed("Right"):
			animation_player("walk",false)
			dir += 1
		if Input.is_action_pressed("Left"):
			animation_player("walk",true)
			dir -= 1
		if dir != 0:
			velocity.x = lerp(velocity.x, dir * speed, acceleration)
		else:
			velocity.x = lerp(velocity.x, 0, friction)
			animation_player("idle",false)
			
	else:
		jump_animation()
		
	if Input.is_action_pressed("Action") and tween_ready:
		if gamestate.shots > 0:
			fire()
			tween_animation("shot")
			animation.play("GunAttack")
			jump()
		else:
			tween_animation("reload")
	
	if Input.is_action_pressed("Reload") and tween_ready:
		tween_animation("reload")

func jump():
	var rotation = calc_rotation_percent()
		
	if(rotation[1] > 0 and rotation[1] <= 90):	
		velocity.x = -(max_jump_speed * (1 - rotation[0]*4))
		velocity.y = -(max_jump_speed + (velocity.x))
		
	elif(rotation[1] > 90 and rotation[1] <= 180):
		velocity.x = (max_jump_speed * ((rotation[0]-0.25) * 4))
		velocity.y = ((velocity.x) - max_jump_speed)

	elif(rotation[1] > 180 and rotation[1] <= 270):
		velocity.x = (max_jump_speed * (1 - (rotation[0] - 0.5) * 4))
		velocity.y = (max_jump_speed - (velocity.x))

	else:
		velocity.x = -(max_jump_speed * (rotation[0]-0.75) * 4)
		velocity.y = (max_jump_speed + velocity.x)

func fire():
	var bullet_instance = bullet.instance()
	
	gamestate.shots -= 1
	bullet_instance.position = gunlance.global_position
	bullet_instance.rotation_degrees = lance.rotation_degrees
	bullet_instance.apply_impulse(Vector2(), Vector2(bullet_speed,0).rotated(lance.rotation))
	gunlance.add_child(bullet_instance)

func animation_player(animationPlayer,reverse):
	$PlayerBody.play(animationPlayer,reverse)

func jump_animation():
	if velocity.y > 0:
		animation_player("jumpDown",false)
	elif velocity.y < 0:
		animation_player("jumpUp",false)
		
func tween_animation(tweenAnimation):
	if tweenAnimation == "shot":
		OverHeat.interpolate_property($LancePivot/Lance, "modulate", color, color - Color(0,0.15,0.15,0), nextShotAnimTime, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		color -= Color(0,0.15,0.15,0)
		OverHeat.start()
	if tweenAnimation == "reload":
		OverHeat.interpolate_property($LancePivot/Lance, "modulate", color, Color(1,1,1,1), reloadAnimTime, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		color = Color(1,1,1,1)
		gamestate.shots = gamestate.maxShots
		OverHeat.start()
		
	tween_ready = false

func calc_rotation_percent():
	var rotation_percent
	var rotation_chk =int(lance.rotation_degrees / 360)
	
	if lance.rotation_degrees > 0:
		rotation_chk = abs(lance.rotation_degrees - (rotation_chk * 360))
	else:	
		rotation_chk = (abs(rotation_chk) + 1) * 360 + lance.rotation_degrees
	
	rotation_percent = rotation_chk / 360
	
	return [rotation_percent, rotation_chk]

func _on_OverHeat_tween_all_completed():
	tween_ready = true

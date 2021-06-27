extends KinematicBody2D

var velocity = Vector2.ZERO
export var speed = 100
export var gravity = 200
export var max_jump_speed = 150
export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.25

var lance
var animation

func _ready():
	animation = $AnimationPlayer
	lance = $LancePivot
	
func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
		
func jump():
	var rotation = calc_rotation_percent()
		
	if(rotation[1] > 0 and rotation[1] <= 90):
		velocity.x = -(max_jump_speed * rotation[0] * 4)
		velocity.y = (max_jump_speed + (velocity.x))
		
	elif(rotation[1] > 90 and rotation[1] <= 180):
		velocity.x = -(max_jump_speed * (1 - (rotation[0]-0.25) * 4))
		velocity.y = (-(velocity.x) - max_jump_speed)
		
	elif(rotation[1] > 180 and rotation[1] <= 270):
		velocity.x = (max_jump_speed * (rotation[0] - 0.5) * 4)
		velocity.y = -(max_jump_speed - (velocity.x))
	else:
		velocity.x = (max_jump_speed * (1 - (rotation[0]-0.75) * 4))
		velocity.y = -(-(velocity.x) - max_jump_speed)
		

func calc_rotation_percent():
	var rotation_percent
	var rotation_chk =int(lance.rotation_degrees / 360)
	
	if lance.rotation_degrees > 0:
			rotation_chk = abs(lance.rotation_degrees - (rotation_chk * 360))
	else:	
			rotation_chk = (abs(rotation_chk) + 1) * 360 + lance.rotation_degrees
						
	rotation_percent = rotation_chk / 360
	
	return [rotation_percent, rotation_chk]

func get_input():
	
#	if is_on_floor():
#		velocity.x = 0
#		if Input.is_action_pressed("Right"):
#			velocity.x += speed
#		if Input.is_action_pressed("Left"):
#			velocity.x -= speed

	if is_on_floor():	
		var dir = 0
		if Input.is_action_pressed("Right"):
			dir += 1
		if Input.is_action_pressed("Left"):
			dir -= 1
		if dir != 0:
			velocity.x = lerp(velocity.x, dir * speed, acceleration)
		else:
			velocity.x = lerp(velocity.x, 0, friction)
		
	if Input.is_action_just_pressed("Action"):
		animation.play("GunAttack")
		jump()

extends KinematicBody2D

export var speed = 32
export var gravity = 400
export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.25

var velocity = Vector2.ZERO
var dir = -1
var lives = 1

func _physics_process(delta):
	diraction()
	move()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
func move():
	if is_on_floor():	
		if dir != 0:
			velocity.x = lerp(velocity.x, dir * speed, acceleration)
		else:
			velocity.x = lerp(velocity.x, 0, friction)
			
func diraction():
	if not $Check.is_colliding():
		dir = -dir
		$Check.position.x = -$Check.position.x


func _on_HitBox_body_entered(body):
	if body.name == "Bullet":
		velocity.y = -50
		velocity.x = dir*velocity.y


func _on_HitBox_area_entered(area):
	if area.name == "LancePivot":
		velocity.y = -50
		velocity.x = dir*velocity.y

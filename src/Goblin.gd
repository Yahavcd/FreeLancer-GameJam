extends KinematicBody2D

export var speed = 32
export var gravity = 400
export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.25
export var hit_velocity = 100
export var invinceble_duarion = 0.5

var velocity = Vector2.ZERO
var dir = -1
var lives = 2
var is_hit = false
var is_dead = false

func _physics_process(delta):
	diraction()
	move()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
func move():
	if is_on_floor():	
		if dir != 0 and !is_dead:
			velocity.x = lerp(velocity.x, dir * speed, acceleration)
		else:
			velocity.x = lerp(velocity.x, 0, friction)

func diraction():
	if not $Check.is_colliding():
		dir = -dir
		$Check.position.x = -$Check.position.x

func _on_HitBox_body_entered(body):
	if body.name == "Bullet":
		hit(self.global_position.x - body.global_position.x)
		$Blinker.start_blinking(self, invinceble_duarion)
		$HitBox.start_invincebility(invinceble_duarion)

func _on_HitBox_area_entered(area):
	if area.name == "LancePivot":
		hit(self.global_position.x - area.get_parent().global_position.x)
		$Blinker.start_blinking(self, invinceble_duarion)
		$HitBox.start_invincebility(invinceble_duarion)

func hit(direction):
	lives -= 1
	is_hit = true
	if lives == 0:
		is_dead = true
		death()
		
	velocity.y = -hit_velocity
	if direction >= 0:
		velocity.x = hit_velocity
	else:
		velocity.x = -hit_velocity

func death():
	is_dead = true
	$HitBox/CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("death")	

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()

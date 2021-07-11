extends KinematicBody2D

export var speed = 32
export var gravity = 400
export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.25
export var hit_velocity = 100
export var invinceble_duarion = 0.1
export var jump_height = -200
export var jump_length = 100

var velocity = Vector2.ZERO
var dir = -1
var lives = 1
var is_hit = false
var difficulty = 1

func _ready():
	randomize()
	if (randi() % 2 + 1) == 1:
		dir = -dir
		$Sprite.flip_h = !$Sprite.flip_h
		$Check.rotation = -$Check.rotation
	difficulty = randi() % gamestate.difficulty + 1
	if difficulty <= 2:
		pass
	elif difficulty <= 4:
		lives = 2
		$Sprite.self_modulate = Color(0.941176, 0.27451, 0.27451)
	else:
		lives = 3
		$Sprite.self_modulate = Color(0.213867, 0.479494, 1)

func _physics_process(delta):
	diraction()
	move()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	if (velocity.y > 700):
		death()
	
func move():
	if is_on_floor():
		if dir != 0 and !$HitBox.is_dead:
			velocity.x = lerp(velocity.x, dir * speed, acceleration)
		else:
			velocity.x = lerp(velocity.x, 0, friction)
			
	if velocity.y > 0:
		$Sprite.play("jumpDown")
	elif velocity.y < 0:
		$Sprite.play("jumpUp")
	else:
		$Sprite.play("walk")
		
		

func diraction():
	if $Check.is_colliding() and is_on_floor():
		dir = -dir
		$Sprite.flip_h = !$Sprite.flip_h
		$Check.rotation = -$Check.rotation

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
		$HitBox.is_dead = true
		death()
		
	velocity.y = -hit_velocity
	if direction >= 0:
		velocity.x = hit_velocity
	else:
		velocity.x = -hit_velocity

func death():
	$HitBox.is_dead = true
	$HitBox/CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("death")	
	gamestate.count_slime += 1

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()


func _on_Timer_timeout():
	if is_on_floor():
		velocity.y = jump_height
		velocity.x = jump_length*dir

extends KinematicBody2D

export var speed = 50
export var gravity = 0
export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.25
export var hit_velocity = 100
export var max_pos = 200
export var attack_velocity = Vector2(100,200)
export var invinceble_duarion = 0.5

var velocity = Vector2.ZERO
var dir = -1
var lives = 2
var is_hit = false
var is_dead = false
var is_attacking = false
var is_soaring = false
var cur_position = max_pos
onready var save_pos_y = global_position.y
var save_speed = speed

func _physics_process(delta):
	attack_player()
	soar()
	finish_soar()
	diraction()
	move()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity)
	
func finish_soar():
	if position.y <= save_pos_y and is_soaring:
		is_soaring = false
		velocity.y = 0
			
func move():
		if dir != 0 and !is_dead:
			velocity.x = lerp(velocity.x, dir * speed, acceleration)
		else:
			velocity.x = lerp(velocity.x, 0, friction)
		
		if !is_soaring and !is_attacking:
			velocity.y = 0
			
func diraction():
	var chk = dir
	if position.x <= -max_pos:
		dir = 1
	if position.x >= max_pos:
		dir = -1
	
	if dir != chk:
		$FindPlayer.rotation = -$FindPlayer.rotation
	
func attack_player():
	if $FindPlayer.is_colliding() and !is_attacking and !is_soaring:
		is_attacking = true
		velocity.y = attack_velocity.y
		speed = attack_velocity.x
		max_pos = 9999

func soar():
	if $Check.is_colliding() and is_attacking:
		is_attacking = false
		is_soaring = true
		speed = save_speed
		velocity.y = -save_pos_y
		max_pos = cur_position

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
	$AnimationPlayer.play("Death")
	$HitBox/CollisionShape2D.set_deferred("disabled", true)
	self.set_collision_mask_bit(2, false)

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()

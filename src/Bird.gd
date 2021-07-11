extends KinematicBody2D

export var speed = 50
export var gravity = 0
export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.25
export var hit_velocity = 100
export var limit_position = 100
export var attack_velocity = Vector2(100,200)
export var invinceble_duarion = 0.1
export var limit_y = 400

var velocity = Vector2.ZERO
var dir = -1
var lives
var attack_pos = 9999
var is_hit = false
var is_attacking = false
var is_soaring = false
var min_pos
var max_pos
var cur_position
var save_pos_y
var save_speed = speed
var difficulty = 1

func _ready():
	max_pos = position.x + limit_position
	min_pos = (position.x - limit_position)
	cur_position = position.x
	save_pos_y = global_position.y
	randomize()
	if (randi() % 2 + 1) == 1:
		dir = -dir
		$Sprite.flip_h = !$Sprite.flip_h
		$FindPlayer.rotation = -$FindPlayer.rotation
	difficulty = randi() % gamestate.difficulty + 1
	if difficulty <= 2:
		lives = 1
		$Sprite.self_modulate = Color(1, 1, 1)
	elif difficulty <= 4:
		lives = 2
		$Sprite.self_modulate = Color(0.941176, 0.27451, 0.27451)
	else:
		lives = 3
		$Sprite.self_modulate = Color(0.213867, 0.479494, 1)

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
		is_attacking = false
		is_hit = false
		velocity.y = 0
			
func move():
		if dir != 0 and !$HitBox.is_dead:
			velocity.x = lerp(velocity.x, dir * speed, acceleration)
		else:
			velocity.x = lerp(velocity.x, 0, friction)
		
		if !is_soaring and !is_attacking and !is_hit:
			velocity.y = 0
			
func diraction():
	var chk = dir
	if !is_attacking:
		if position.x <= min_pos:
			dir = 1
			$Sprite.flip_h = true
		if position.x >= max_pos:
			dir = -1
			$Sprite.flip_h = false
	else:
		if position.x <= -attack_pos:
			dir = -1
			$Sprite.flip_h = false
		if position.x >= attack_pos:
			dir = 1
			$Sprite.flip_h = true
		
	
	if dir != chk:
		$FindPlayer.rotation = -$FindPlayer.rotation
	
func attack_player():
	if $FindPlayer.is_colliding() and !is_attacking and !is_soaring:
		is_attacking = true
		velocity.y = attack_velocity.y
		speed = attack_velocity.x
		$Sprite.play("Attack")

func soar():
	if (is_attacking and ($Check.is_colliding() or is_hit)) or position.y >= limit_y + save_pos_y:
		is_soaring = true
		speed = save_speed
		velocity.y = -speed/2
		if is_hit:
			velocity.y = - hit_velocity
		$Sprite.play("Fly")
			

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
		death()

	if direction >= 0:
		velocity.x = hit_velocity
	else:
		velocity.x = -hit_velocity

func death():
	$HitBox.is_dead = true
	$AnimationPlayer.play("Death")
	$HitBox/CollisionShape2D.set_deferred("disabled", true)
	self.set_collision_mask_bit(2, false)
	gamestate.count_bird += 1

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()

extends KinematicBody2D

export var speed = 32
export var gravity = 400
export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.25
export var hit_velocity = 100
export var invinceble_duarion = 1
export var jump_height = -200
export var jump_length = 100

var velocity = Vector2.ZERO
var dir = -1
var lives = 10
var is_attacking = false
signal is_hit 
var difficulty = 1

func _ready():
	randomize()
	difficulty = randi() % gamestate.difficulty + 1
	if difficulty <= 2:
		pass
	elif difficulty <= 4:
		lives = 20
		$Sprite.self_modulate = Color(0.941176, 0.27451, 0.27451)
	else:
		lives = 30
		$Sprite.self_modulate = Color(0.213867, 0.479494, 1)

func _physics_process(delta):
	diraction()
	move()
	attack()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)


func attack():
	if $CheckPlayer.is_colliding() and !is_attacking:
		$CheckPlayer.set_deferred("enabled",false)
		$HeadBox.set_deferred("disabled",true)
		velocity.x = 0
		is_attacking = true
		$Sprite.play("attack1")
		yield(get_tree().create_timer(0.6),"timeout")
		$Attack/CollisionShape2D.set_deferred("disabled",false)
		$Sprite.play("attack2")
		$Timer.start()
		
	
func move():
	if is_on_floor() and !is_attacking:
		if dir != 0 and !$HeadBox.is_dead:
			velocity.x = lerp(velocity.x, dir * speed, acceleration)
		else:
			velocity.x = lerp(velocity.x, 0, friction)
			
	if !is_attacking:		
		if velocity.y != 0:
			$Sprite.play("jump")
		else:
			$Sprite.play("walk")
		

func diraction():
	if $Check.is_colliding() and is_on_floor():
		dir = -dir
		$Sprite.flip_h = !$Sprite.flip_h
		$Check.rotation = -$Check.rotation
		$CheckPlayer.rotation = -$CheckPlayer.rotation
		$HeadBox.position.x = -$HeadBox.position.x
		$HitBox.position.x = -$HitBox.position.x
		$Attack/CollisionShape2D.position.x = -$Attack/CollisionShape2D.position.x
		$CollisionShape2D.position.x = -$CollisionShape2D.position.x

func hit(_direction):
	emit_signal("is_hit",invinceble_duarion)
	lives -= 1
	if lives == 0:
		$HeadBox.is_dead = true
		death()

func death():
	$HeadBox.is_dead = true
	$HeadBox/CollisionShape2D.set_deferred("disabled", true)
	$AnimationPlayer.play("death")	
	gamestate.count_boss += 1
	gamestate.mission_count +=1

func _on_AnimationPlayer_animation_finished(_anim_name):
	get_tree().change_scene("res://Scenes/Screen/LevelFinished.tscn")


func _on_HeadBox_area_entered(area):
	if area.name == "LancePivot":
		hit(self.global_position.x - area.get_parent().global_position.x)
		$Blinker.start_blinking(self, invinceble_duarion)
		$HeadBox.start_invincebility(invinceble_duarion)


func _on_HeadBox_body_entered(body):
	if body.name == "Bullet":
		hit(self.global_position.x - body.global_position.x)
		$Blinker.start_blinking(self, invinceble_duarion)
		$HeadBox.start_invincebility(invinceble_duarion)


func _on_Timer_timeout():
		is_attacking = false
		$CheckPlayer.set_deferred("enabled",true)
		$HeadBox.set_deferred("disabled",false)
		$Attack/CollisionShape2D.set_deferred("disabled",true)

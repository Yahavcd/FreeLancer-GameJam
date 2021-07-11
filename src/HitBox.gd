extends Area2D

var collision_shape

var is_invinceble = false
var is_dead = false

func _ready():
	collision_shape = $CollisionShape2D

func start_invincebility(invinceble_duarion):
	if invinceble_duarion > 0 or is_dead:
		collision_shape.set_deferred("disabled",true)
		is_invinceble = true
		yield(get_tree().create_timer(invinceble_duarion),"timeout")
		if !is_dead:
			collision_shape.set_deferred("disabled",false)
			is_invinceble = false


func _on_MinotaorBoss_is_hit(invinceble_duarion):
	start_invincebility(invinceble_duarion)

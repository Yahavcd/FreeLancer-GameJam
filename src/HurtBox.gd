extends Area2D

const whiten_duration = 0.20
export (ShaderMaterial) var whiten_matetial
var collision_shape

var is_invinceble = false

func _ready():
	collision_shape = $CollisionShape2D

func start_invincebility(invinceble_duarion):
	is_invinceble = true
	collision_shape.set_deferred("disabled",true)
	yield(get_tree().create_timer(invinceble_duarion),"timeout")
	collision_shape.set_deferred("disabled",false)
	is_invinceble = false

func _on_HurtBox_area_entered(area: Area2D) -> void:
	if area.name == "LancePivot" or area.name == "HitBox":
		whiten_matetial.set_shader_param("whiten", true)
		yield(get_tree().create_timer(whiten_duration),"timeout")
		whiten_matetial.set_shader_param("whiten", false)

func _on_HurtBox_body_entered(body):
	if body.name == "Bullet":
		whiten_matetial.set_shader_param("whiten", true)
		yield(get_tree().create_timer(whiten_duration),"timeout")
		whiten_matetial.set_shader_param("whiten", false)

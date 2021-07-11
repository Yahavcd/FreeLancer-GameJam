extends ParallaxLayer

onready var tween = $Tween
var start_pos = 0
export var time = 40

func _ready():
	tween.interpolate_property(self, "motion_offset", Vector2(0,start_pos), Vector2(0,start_pos-256), time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _on_Tween_tween_all_completed():
	start_pos  = motion_offset.y
	tween.interpolate_property(self, "motion_offset", Vector2(0,start_pos), Vector2(0,start_pos-256), time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

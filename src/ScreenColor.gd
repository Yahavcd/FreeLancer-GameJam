extends ColorRect

onready var tween = $Tween
var time = 25
var tween_state = 1

var color1 = Color(0, 0, 0, 0.588235)
var color2 = Color(1, 1, 1, 0)

func _ready():
	self.color = color1
	tween.interpolate_property(self, "color", color1, color2, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _on_Tween_tween_all_completed():
	var temp
	temp = color1
	color1 = color2
	color2 = temp
	if tween_state == 1:
		time = 15
	else:
		time = 25
	tween_state *=-1
	tween.interpolate_property(self, "color", color1, color2, time, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

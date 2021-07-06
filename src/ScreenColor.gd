extends ColorRect

onready var sun = self.get_parent().get_node("ParallaxBackground/SunLayer")
onready var tween = $Tween
export var time = 28

var color1 = Color(0, 0, 0, 0.588235)
var color2 = Color(1, 1, 1, 0)

func _ready():
	tween.interpolate_property(self, "color", color1, color2, time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()
	


func _on_Tween_tween_completed(_object, _key):
	var temp
	temp = color1
	color1 = color2
	color2 = temp
	tween.interpolate_property(self, "color", color1, color2, time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

extends Line2D

var time
onready var tween = $Tween

func _ready():
	points[1].x = 0
	self.hide()

func finished():
	self.hide()

func started():
	tween.remove_all()
	points[1].x = 0
	tween.interpolate_method(self, "update_point", 0, 14, time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	self.show()
	
func _on_Player_is_reloading(calc_reloadtime):
	time = calc_reloadtime
	started()

func _on_Tween_tween_all_completed():
	print("done")
	finished()

func update_point(pos):
	points[1].x = pos

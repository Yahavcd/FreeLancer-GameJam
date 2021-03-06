extends Node

var blink_timer
var duration_timer
var blink_object: Node2D 

func _ready():
	blink_timer = $BlinkTimer
	duration_timer = $DurationTimer

func start_blinking(object, duration):
	if duration > 0:
		blink_object = object
		duration_timer.wait_time = duration
		duration_timer.start()
		blink_timer.start()
	

func _on_DurationTimer_timeout():
	blink_timer.stop()
	blink_object.visible = true


func _on_BlinkTimer_timeout():
	blink_object.visible = !blink_object.visible

extends Label

func _process(_delta):
	if Input.is_action_pressed("Action"):
		queue_free()
		

func _on_Blink_timeout():
	self.visible = !self.visible

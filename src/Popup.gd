extends Popup

func _process(_delta):
	if Input.is_action_pressed("Action"):
		self.popup()

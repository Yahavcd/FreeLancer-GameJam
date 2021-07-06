extends ParallaxLayer

export (float) var sun_speed = -5

func _process(delta):
	self.motion_offset.y += sun_speed * delta


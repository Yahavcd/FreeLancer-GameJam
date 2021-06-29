extends ParallaxLayer

export (float) var cload_speed = -15

func _process(delta):
	self.motion_offset.x += cload_speed * delta 


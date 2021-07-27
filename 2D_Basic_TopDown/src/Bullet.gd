extends Area2D
class_name Bullet

# Max speed of a bullet
const BULLET_SPEED: float = 1000.0

# Every time physics update
func _physics_process(delta):
	
	# move bullet forward (-transform.y is up direction) with specified speed
	# delta is used to make bullet move with the same speed regardless of framerate.
	position += -transform.y * BULLET_SPEED * delta

# when bullet hits something
func _on_Bullet_body_entered(body):
	
	# we will check what type of object bullet hit and decide what to do
	match body.get_script():
		# if body that bullet hit is obstacle
		Obstacle:
			# then delete this body. "call_defered" is used to delete nodes safely.
			(body as Obstacle).call_deferred("free")
	
	# Also delete the bullet
	call_deferred("free")

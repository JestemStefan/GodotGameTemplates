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
	
	# if bullet hits obstacle
	if body is Obstacle:
		# then do nothing since I don't want obstacle to be destroyed
		pass
	
	# if body hits Enemy
	if body is Enemy:
		
		# then enemy will take damage
		(body as Enemy).take_damage()
	
	
	# Also delete the bullet at the end
	call_deferred("free")

extends KinematicBody2D
class_name Player

# velocity variable is used to store movement vector (direction and speed) of your character
var velocity: Vector2 = Vector2.ZERO

# how fast your character will rotate/turn
const ROTATION_SPEED: float = 5.0
# maximum speed of your character
const MAX_SPEED: float = 250.0
# how fast your character will accelerate
const ACCELERATION_SPEED: float = 5.0

# export will create an entry box in inspector where you can drag and drop a projectile your character will fire
# Click on Player node in Scene tab and check Inspector Under Script Variables you will see [Projectile Instance].
export var projectile_instance: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# direction variable will store input from the player. We reset it to (0,0) every frame
	var direction: Vector2 = Vector2.ZERO
	# we will use new_velocity to generate new vector(direction and speed) from input
	var new_velocity: Vector2 = Vector2.ZERO
	
	# # this sets direction when you press arrow keys.
	
	# -------------IF YOU ARE USING VERSION 3.3 OR EARLIER THEN YOU CAN USE THIS ------
	
	# Input.get_action_strength() gives 1 when you press button and 0 if you don't
	# So if you press just right it will be 1 - 0 = 1 --> going right
	# if you press left: 0 - 1 = -1 --> going left
	# if both left and right will be pressed then 1 - 1 = 0 --> no movement
	
	# left and right direction will be used for rotation
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	# up and down will be used for going forward and backward
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	# -------------IF YOU ARE USING VERSION 3.4 OR LATER THEN YOU CAN USE THIS INSTEAD ------
	# Input.get_vector() will take a direction of input so it will be in up direction if you press up 
	#direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# set character new velocity to input direction multiplied by speed
	# lerp is used to make smooth acceleration from previous velocity to new velocity
	new_velocity = lerp(velocity, direction.y * transform.y * MAX_SPEED, ACCELERATION_SPEED * delta)
	
	# rotate character based on player input and rotation speed
	rotate(direction.x * ROTATION_SPEED * delta)
	
	# apply all input changes to velocity
	velocity = move_and_slide(new_velocity)
	
	# when you press space
	if Input.is_action_just_pressed("ui_select"):
		
		# Check if you set what projectile should be used in Inspector tab
		if is_instance_valid(projectile_instance): # if projectile is set
			
			# create a new bullet from projectile instance
			var bullet: Bullet = projectile_instance.instance()
			# add it to the scene in which player move
			get_parent().add_child(bullet)
			# place bullet in front of a player so you will not shoot yourself
			bullet.position = position - transform.y * 50
			# rotate bullet so it will face direction it's going
			bullet.rotation = rotation
		
		# if you forgot to set a bullet scene then we will print an error to console
		else:
			printerr("It seems you forgot to add scene to Projectile Instance in Inspector tab of a Player node")

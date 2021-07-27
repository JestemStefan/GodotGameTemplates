extends KinematicBody2D

# Movement direction of your character
var velocity: Vector2 = Vector2.ZERO
# max speed of your character
const MAX_SPEED: float = 250.0
# how fast your player will reach max speed. Increase to accelerate faster
const ACCELERATION: float = 0.2
# gravity value. Make it smaller and character will fall slower and feel light
# make it bigger and it will fall faster and feel heavier
var gravity: float = 1500

# We will use Raycast2D node to detect collision with the floor.
onready var floor_ray: RayCast2D = $FloorRay

# Used to check how many times player can jump. 2 = double jump. 1 single jump. 0 = can't jump
const MAX_JUMP_CHARGES: int = 1
var jumpChargesLeft: int = MAX_JUMP_CHARGES

# this makes game feel good
# jump buffer checks if player pressed jump button recently.
# It will make character jump even if character wasn't on floor while player pressed button
const JUMP_BUFFER_LENGTH: float = 0.3
var jump_buffer: float = 0

# coyote time! We will use this to let player jump even if he is not on platform anymore
const COYOTE_TIME_LENGTH: float = 0.3
var coyote_time_buffer: float = 0

# this value is how high your player will jump. Must be minus value
const JUMP_FORCE: float = -500.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	# reset direction of the imput
	var direction: Vector2 = Vector2.ZERO
	
	# this sets left/right direction when you press left/right arrow.
	# Input.get_action_strength() gives 1 when you press button and 0 if you don't
	# So if you press just right it will be 1 - 0 = 1 --> going right
	# if you press left: 0 - 1 = -1 --> going left
	# if both left and right will be pressed then 1 - 1 = 0 --> no movement
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	# check if player landed on the ground and if he does then he can jump again
	if floor_ray.is_colliding():
		jumpChargesLeft = MAX_JUMP_CHARGES
		coyote_time_buffer = COYOTE_TIME_LENGTH
	# if player is not on ground then lower coyote time
	else:
		coyote_time_buffer -= 1 * delta
	
	# check if player pressed jump button and if he does then add coyote time
	# if you want to jump on space then use "ui_select". 
	# If you want to jump using up then "up arrow" or "W" then change it to: "ui_up"
	if Input.is_action_just_pressed("ui_select"):
		jump_buffer = JUMP_BUFFER_LENGTH
		
	# if jump buffer is activated
	if jump_buffer > 0:
		# if player didn't jump yet and he was on a the ground
		if jumpChargesLeft > 0 and coyote_time_buffer > 0:
			
			velocity.y = JUMP_FORCE # add force up to jump
			jumpChargesLeft -= 1 * delta 	# use one of jump charges
			jump_buffer = 0			# jump buffer is used up to reset to 0
		
		# if player can't jump then reduce jump buffer
		else:
			jump_buffer -= 1 * delta
	
	# set character movement to input direction multiplied by speed
	# lerp is used to make smooth acceleration
	velocity.x = lerp(velocity.x, direction.x * MAX_SPEED, ACCELERATION)
	
	# add gravity every frame even when player is on ground. Very important!
	velocity.y += gravity * delta
	
	# apply all input changes to velocity
	velocity = move_and_slide(velocity)

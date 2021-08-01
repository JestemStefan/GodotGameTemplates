extends KinematicBody2D
class_name Enemy

# get reference to player. Of the way to do this is to add player to group "Player"
# and then call this get_tree().get_nodes_in_group("Player"). 
# [0] at the end means we take first object and since player is the first and only object in this group
onready var player_reference = get_tree().get_nodes_in_group("Player")[0]

# Speed of enemy
const enemy_speed: float = 5000.0

# amount of hits enemy can take before dying
var enemy_health: int = 3

# _ready is called when the node enters the scene tree for the first time.
# we will update enemy health status
func _ready():
	update_health()

# this method runs every frame
func _physics_process(delta):
	# we will make enemy chase the player
	var direction_to_player: Vector2 = Vector2.ZERO
	
	# we check if player even exists
	if is_instance_valid(player_reference):
		
		# the easiest way to do this is to take enemy position in the game world (self.global_position)
		# then we position of the player in game world (player_reference.global_position)
		# to get direction we can use method called direction_to() which gives as vector()
		# from enemy position to player position
		 direction_to_player = self.global_position.direction_to(player_reference.global_position)
	
	# we move enemy in the direction of player. We multiply it by speed to move it faster
	# and we multiply it by delta to take it run the same regardless of framerate (delta is time between frames)
	move_and_slide(direction_to_player * enemy_speed * delta)


# this mathod is called when enemy takes damage
func take_damage():
	
	# we lower the health
	enemy_health -= 1
	
	# and we update the health
	update_health()
	

# this method should be called every time enemy health change
func update_health():
	
	# we check what current enemy health is and we decide what to do
	match enemy_health:
		# Sprite.modulate changes color of the sprite
		#-----------------------------------------------------------------------
		# if it's 3 then I want enemy to have "normal" (white) color
		3: 
			$Sprite.modulate = Color.white
		
		#-----------------------------------------------------------------------
		# if it's 2 then I want enemy to turn orange
		2: 
			$Sprite.modulate = Color.orange
		
		#-----------------------------------------------------------------------
		# if it's 1 then I want enemy to turn red
		1: 
			$Sprite.modulate = Color.red
		
		#-----------------------------------------------------------------------
		# if enemy health is 0 then we will not change color, because it should die
		0: 
			pass
		
		#-----------------------------------------------------------------------
	
	# if enemy health is 0 the we will delete it at the end of the frame
	# we use call_defered() to do something at the end of the frame
	if enemy_health <= 0:
		call_deferred("free")

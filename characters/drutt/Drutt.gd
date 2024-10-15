class_name Drutt

extends CharacterBody2D

signal drutt_ate_worm(worm)

@onready var sprite = $AnimatedSprite2D
@onready var worm_eating_timer = $WormEatingTimer
@onready var eat_area: Area2D = $Eat

var worms: Node2D

var target_worm
var buzzing = false;
var speed = 400
var burping = false


var direction = Vector2.ZERO  # Current movement direction

# Movement vectors
var up = Vector2(0, -1)
var down = Vector2(0, 1)
var left = Vector2(-1, 0)
var right = Vector2(1, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector2.ZERO
	
	if (burping):
		sprite.play("burp")
	elif (buzzing):
		sprite.play("buzzing")
	else:	
		sprite.play("walking_forward")
		velocity = direction * speed
		
		if move_and_slide():
			set_direction_away_from_collision(get_last_slide_collision())
			target_worm = null
		elif (target_worm):
			if (eat_area.overlaps_body(target_worm)):
				eat_or_chase(target_worm)
			else:
				set_direction_towards_worm()
		elif(worms.get_children().size() > 0):	
			find_closest_worm()

	
	
func set_direction_towards_worm():
	# Calculate the difference between the character and the worm's position
	var direction_to_worm = target_worm.global_position - global_position
	
	# Normalize the direction to get the movement direction restricted to X or Y axis
	if abs(direction_to_worm.x) > abs(direction_to_worm.y):
		# Prioritize horizontal movement
		if direction_to_worm.x > 0:
			direction = right
		else:
			direction = left
	else:
		# Prioritize vertical movement
		if direction_to_worm.y > 0:
			direction = down
		else:
			direction = up
	
	
		
	# Function to handle collision and move around the object
func set_direction_away_from_collision(collision):
	var normal = collision.get_normal()  # The normal of the surface that was collided with

	# If colliding with a wall or object, adjust direction to move around it
	if abs(normal.x) > abs(normal.y):
		# Collision is more horizontal, adjust vertical movement
		if normal.x > 0:
			direction = down if direction == right else up  # If hit from the right, go down or up
		else:
			direction = up if direction == left else down  # If hit from the left, go up or down
	else:
		# Collision is more vertical, adjust horizontal movement
		if normal.y > 0:
			direction = left if direction == down else right  # If hit from below, go left or right
		else:
			direction = right if direction == up else left  # If hit from above, go left or right		

func find_closest_worm():
	var closest_distance = INF  # Start with a large value
	var closest_worm = null
	
	# Iterate through all worms in the collection
	for worm in worms.get_children():
		# Calculate the distance between the character and the worm
		var distance_to_worm = global_position.distance_to(worm.global_position)
		
		# If this worm is closer than the previous closest, store it
		if distance_to_worm < closest_distance:
			closest_distance = distance_to_worm
			closest_worm = worm
	
	# Set the closest worm as the target worm
	target_worm = closest_worm
	if (target_worm):
		set_direction_towards_worm()
	

func _on_worm_radar_body_entered(body):
	if body.is_in_group("worm"):
		body.set_enemy(self)


func _on_worm_radar_body_exited(body):
	if body.is_in_group("worm"):
		body.set_enemy(null)


	
func _on_eat_body_entered(body):
	if body.is_in_group("worm"):
		eat_or_chase(body)
		

func eat_or_chase(worm):			
	if burping or buzzing:
		worm.accelerate()
	else:
		burping = true
		emit_signal("drutt_ate_worm", worm)
		worm_eating_timer.start(1)	

func _on_animated_sprite_2d_animation_finished():
	if burping:
		burping = false
		buzzing = true
		

func _on_worm_eating_timer_timeout():
	buzzing = false
	

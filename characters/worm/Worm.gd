class_name Worm
extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
# Speed of the worm's movement
var original_speed = 200
var speed = original_speed

# Directions in which the worm can move
var directions = [
	[Vector2(-1, 0), 0, false],    # Left
	[Vector2(1, 0), 0, true],     # Right
	[Vector2(-1, -1), 45, false],   # Diagonally Up Left
	[Vector2(1, -1), -45, true],    # Diagonally Up Right
	[Vector2(-1, 1),-45, false],    # Diagonally Down Left
	[Vector2(1, 1), 45, true]      # Diagonally Down Right
]
# Current direction of the worm
var current_direction = Vector2.ZERO

# Example colors for different worms
var worm_colors = [
	Color(1, 0.5, 0),    # Orange (default color)
	Color(0.5, 1, 0),    # Greenish
	Color(0, 0.5, 1),    # Blueish
	Color(1, 0, 0),      # Red
	Color(1, 1, 0),      # Yellow
]

# Function to randomly assign a color to the worm

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play("default")
	set_random_color()
	choose_random_direction()

func _process(delta):
	velocity = current_direction * speed
	while (move_and_slide()):
		choose_random_direction()
		velocity = current_direction * speed
	
	
		

# Function to randomly select a new direction
func choose_random_direction():
	# Pick a random index from the directions array
	var dir = directions[randi() % directions.size()]
	current_direction = dir[0].normalized()
	sprite.rotation_degrees = dir[1]
	sprite.flip_h = dir[2]
	
func set_random_color():
	var shader_material = sprite.material.duplicate() as ShaderMaterial
	sprite.material = shader_material
	shader_material.set_shader_parameter("tint_color", worm_colors[randi() % worm_colors.size()])

func turn_back():
	current_direction = current_direction * Vector2(-1, -1)
	sprite.flip_h = !sprite.flip_h
	

func avoid(enemy: CharacterBody2D):
	var to_character_normalized = (enemy.global_position - global_position).normalized()
	var dot_product = current_direction.dot(to_character_normalized)
	
	if dot_product > 0:  
		speed *= 2
		current_direction = -current_direction
		sprite.flip_h = !sprite.flip_h
		
func set_enemy(enemy):
	if (enemy):
		avoid(enemy)
	else:
		speed = original_speed
		
func accelerate():
	speed *= 5


func _on_personal_space_body_entered(body):
	if body.is_in_group("worm"):
		var old = current_direction
		while(current_direction == old):
			choose_random_direction()
			
		speed *= 1.2
			


func _on_personal_space_body_exited(body):
	if body.is_in_group("worm"):
		speed = original_speed

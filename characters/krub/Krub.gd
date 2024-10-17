class_name Krub
extends CharacterBody2D

@onready var animation_player = $AnimationPlayer

@onready var worm_caught_timer = $WormCatchTimer

# Speed of the character
var speed: float = 300.0
var top_down_speed: float = 150.0

var bucket : Bucket
var worm_nearby

signal worm_caught(worm)
signal released_bucket(bucket)
signal feed_monster
signal pickup_bucket(krub)
signal open_trapdoor

enum State { IDLE, HOLDING_BUCKET, CATCHING_WORMS, NEAR_TRAPDOOR, NEAR_BUCKET, NEAR_ELEVATOR }
var current_state = State.IDLE

func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	if Input.is_action_pressed("down"):
		velocity = Vector2(0, top_down_speed)
		animate("walk")
	elif Input.is_action_pressed("up"):
		velocity = Vector2(0, -top_down_speed)
		animate("walk")
	elif Input.is_action_pressed("left"):
		velocity = Vector2(-speed, 0)
		animate("walk_left")
	elif Input.is_action_pressed("right"):
		velocity = Vector2(speed, 0)
		animate("walk_right")
	else:
		animate("idle")

	move_and_slide()

func animate(animation):
	if (bucket):
		bucket.global_position = $BucketPlaceHolder.global_position
		animation_player.play(animation+"_with_bucket")
	else:
		animation_player.play(animation)

func release_bucket():
	emit_signal("released_bucket", bucket)
	if bucket.overlaps_body(self):
		current_state = State.NEAR_BUCKET
	else:
		current_state = State.IDLE    
	bucket = null 
	
	
func catch_worm():
	current_state = State.HOLDING_BUCKET
	bucket.add_worm(worm_nearby)
	emit_signal("worm_caught", worm_nearby)
	worm_nearby = null
	worm_caught_timer.start(2)
	if bucket.worms.size() == 10:
		emit_signal("feed_monster")
	
func _on_worm_radar_body_entered(body):
	if body.is_in_group("worm"):
		body.set_enemy(self)

func _on_worm_radar_body_exited(body):
	if body.is_in_group("worm"):
		body.set_enemy(null)

func reset_to_previous_state():
	if bucket:
		current_state = State.HOLDING_BUCKET
	else:
		current_state = State.IDLE
			
func set_near_bucket(near):
	if near:
		current_state = State.NEAR_BUCKET
	else:
		reset_to_previous_state()
	
func set_near_trapdoor(near):
	if near and current_state != State.NEAR_BUCKET:
		current_state = State.NEAR_TRAPDOOR
	else:
		reset_to_previous_state()
		
func _on_catch_worm_body_entered(body):
	if body.is_in_group("worm"):
		if current_state == State.HOLDING_BUCKET:
			worm_nearby = body
			current_state = State.CATCHING_WORMS
		else:
			body.accelerate()


func _on_catch_worm_body_exited(body):
	if body.is_in_group("worm"):
		if body == worm_nearby:
			worm_nearby = null
			reset_to_previous_state()


func set_bucket(bucket: Bucket):
	self.bucket = bucket
	bucket.z_index = z_index + 1
	current_state = State.HOLDING_BUCKET
	
func _input(event):
	if  event.is_action_pressed("space"):
		if current_state == State.CATCHING_WORMS:
			catch_worm()
	elif  event.is_action_pressed("interact"):
		if current_state == State.NEAR_BUCKET:
			emit_signal("pickup_bucket", self)
		elif current_state == State.NEAR_TRAPDOOR:
			emit_signal("open_trapdoor")
		elif current_state == State.HOLDING_BUCKET:
			release_bucket()
		

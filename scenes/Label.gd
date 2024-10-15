extends Label

enum State  {START, BURP, IDLE}
var current_state = State.START
var no_of_animations = 0 
var original_position
var original_scale

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start():
	current_state = State.START
	$AnimationPlayer.play("start")
	text = "KRUB, FEED ME!!!!"
	$Timer.start(6)
	
func monster_fed():
	self.show()
	current_state = State.BURP
	text = "BURP !!!"
	modulate = Color.WHITE
	original_position = position
	original_scale = scale
	pivot_offset = size/2
	$Timer.start(0.1)

func vibrate():
	var burp_intensity = 1.5	
	var vibration_intensity = 0.1	
	
	var temp = randf_range(1.0, burp_intensity)
	scale = original_scale * Vector2(temp, temp)
	rotation = randf_range(-0.1, 0.1)
	position = original_position + Vector2(
		randf_range(-vibration_intensity, vibration_intensity), 
		randf_range(-vibration_intensity, vibration_intensity)
	)
	
func _on_animation_player_animation_finished(anim_name):
	no_of_animations += 1
	if (no_of_animations == 3):
		$AnimationPlayer.stop()
		self.hide()


func _on_timer_timeout():
	if current_state == State.START:
		$AnimationPlayer.stop()
		reset()
	elif current_state == State.BURP:
		vibrate()
		no_of_animations += 1
		if no_of_animations == 20:
			reset()
			
func reset():
	self.hide()
	$Timer.stop()
	current_state = State.IDLE
	no_of_animations = 0

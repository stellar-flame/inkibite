extends Path2D


@onready var path_follow : PathFollow2D = $PathFollow2D
@onready var speed = 200
@onready var timer = $PathFollow2D/Timer
@onready var drutt = $PathFollow2D/Drutt

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start(3)
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):				
	# Calculate the new offset based on speed, direction, and delta time
	if !drutt.buzzing:
		var new_offset = path_follow.progress + (speed  * delta)
		path_follow.progress = new_offset
	

func _on_timer_timeout():
	drutt.buzz()
	timer.start(8)

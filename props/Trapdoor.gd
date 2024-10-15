extends StaticBody2D

@onready var door_handle_message = $DoorHandle/Label

@onready var sprite = $AnimatedSprite2D
@onready var timer = $Timer
@onready var colliosion_shape = $CollisionPolygon2D

signal trapdoor_opened

var open = false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_collision_layer_value(1, false)
	sprite.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func open_door():
	open = true
	door_handle_message.text = "Close"
	sprite.play("open")
	emit_signal("trapdoor_opened")
	set_collision_layer_value(1, true)
	$Timer.start(5)

func close_door():
	open = false
	door_handle_message.text = "Open"
	sprite.y_sort_enabled = false
	sprite.play("close")
	set_collision_layer_value(1, false)
	


func _on_body_entered(body):
	if body.is_in_group("Krub"):
		if open:
			door_handle_message.text = "Close"
		else:
			door_handle_message.text = "Open"
		door_handle_message.show()
		body.set_near_trapdoor(true)

func _on_body_exited(body):
	if body.is_in_group("Krub"):
		door_handle_message.hide()
		body.set_near_trapdoor(false)


func _on_timer_timeout():
	close_door()
	timer.stop()
	

func _on_krub_open_trapdoor():
	if not open:
		open_door()
	else:
		close_door()

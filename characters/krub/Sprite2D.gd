extends AnimatedSprite2D

@onready var bucket_label = $BucketLabel
var bucket_label_start_pos
# Called when the node enters the scene tree for the first time.
func _ready():
	bucket_label.hide()
	bucket_label_start_pos = bucket_label.position
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_frame_changed():
	if animation.ends_with("with-bucket"):
		bucket_label.show()
	else:
		bucket_label.hide()
		
	if animation == "idle-with-bucket":
		bucket_label.position = bucket_label_start_pos
		
	elif animation == "walking-forward-with-bucket" and frame == 0:
		bucket_label.position = bucket_label_start_pos
	elif animation == "walking-forward-with-bucket" and frame == 1:
		bucket_label.position = bucket_label_start_pos + Vector2(-10, -25)
		
	elif animation == "walking-right-with-bucket" and frame == 0:
		bucket_label.position = bucket_label_start_pos + Vector2(200, -5)
	elif animation == "walking-right-with-bucket" and frame == 1:
		bucket_label.position = bucket_label_start_pos + Vector2(210, -35)
	elif animation == "walking-right-with-bucket" and frame == 2:
		bucket_label.position = bucket_label_start_pos + Vector2(150, 22)
	elif animation == "walking-right-with-bucket" and frame == 3:
		bucket_label.position = bucket_label_start_pos + Vector2(135, 15)
		
	elif animation == "walking-left-with-bucket" and frame == 0:
		bucket_label.hide()
	elif animation == "walking-left-with-bucket" and frame == 1:
		bucket_label.hide()
	elif animation == "walking-left-with-bucket" and frame == 2:
		bucket_label.position = bucket_label_start_pos + Vector2(40, -60)
	elif animation == "walking-left-with-bucket" and frame == 3:
		bucket_label.position = bucket_label_start_pos + Vector2(40, -90)


func _on_animation_changed():
	_on_frame_changed()

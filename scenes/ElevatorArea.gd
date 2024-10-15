extends Area2D

signal monster_fed(bucket)

var bucket : Bucket

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("idle")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (bucket):
		bucket.global_position = $Marker2D.global_position - Vector2(0, -30)
	

func show_label(show, text=""):
	if show:
		$Label.text = text
		$Label.show()
	else:
		$Label.hide()
	

func elevate():
	if bucket.worms.size() >= 10: 
		show_label(false)
		$AnimationPlayer.play("up")
	else:
		show_label(true,  "Need 10 worms")

func _on_animation_player_animation_finished(anim_name):
	if bucket and anim_name == "up":
		$AnimationPlayer.play_backwards("up")
		emit_signal("monster_fed", bucket)
		bucket = null
		

func remove_bucket():
	if bucket:
		bucket.hide() 
		

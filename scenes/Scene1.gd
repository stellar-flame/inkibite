extends Node2D

@onready var characters = $Characters
@onready var krub: Krub = $Characters/Krub
@onready var buzzles: Buzzles = $Characters/Buzzles
@onready var trapdoor = $Characters/Trapdoor
@onready var worms = $Characters/Worms
@onready var elevator_area : Area2D= $ElevatorArea
	
var WormScene = load("res://characters/worm/Worm.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	buzzles.worms = worms
	$HUD/StartButton.process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func reset_scene():
	get_tree().change_scene_to_file("res://scenes/Scene1.tscn")
	

func _on_trapdoor_trapdoor_opened():
	await get_tree().create_timer(0.5).timeout
	
	var total = 10-get_worms().size()
	for i in total:
		var worm = WormScene.instantiate()
		worm.position = Vector2(trapdoor.global_position.x, trapdoor.global_position.y + 200)
		worms.add_child(worm)
		
		
func get_worms():
	var arr = []
	for w in worms.get_children():
		if w.is_in_group("worm"):
			arr.append(w)
	return arr
	
func _on_worm_area_body_exited(body):
	if body.is_in_group("worm"):
		body.turn_back()


func _on_worm_area_body_entered(body):
	if body.is_in_group("worm"):
		body.choose_random_direction()
		
	
func _on_elevator_area_monster_fed(bucket):
	characters.remove_child(bucket)
	bucket.queue_free()
	$GameMessages.monster_fed()
	await get_tree().create_timer(3).timeout
	reset_scene()

func _on_start_button_button_down():
	get_tree().paused = false 
	$HUD/StartButton.hide()
	await get_tree().create_timer(1).timeout
	$GameMessages.start()



func _on_krub_worm_caught(worm):
	remove_worm(worm)

func remove_worm(worm):
	if buzzles.target_worm == worm:
		buzzles.target_worm = null
	worms.remove_child(worm)


func _on_krub_released_bucket(bucket):
	if elevator_area.overlaps_body(krub):
		elevator_area.bucket = bucket
		elevator_area.elevate()
	else:
		bucket.global_position = krub.position + Vector2(5, 20)
		bucket.z_index = z_index
	

func _on_bucket_bucket_picked_up(bucket):
	if (elevator_area.bucket):
		elevator_area.bucket = null
		


func _on_krub_feed_monster():
	elevator_area.show_label(true, "Place Bucket Here")


func _on_buzzles_ate_worm(worm):
	remove_worm(worm)
	worm.queue_free()

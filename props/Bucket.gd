class_name Bucket
extends Area2D


@onready var message = $Label  # Adjust the path as necessary
@onready var count = $CountLabel # Adjust the path as necessary

var worms: Array
signal bucket_picked_up(bucket)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Worms/Label.text = str(worms.size()) + "/10"

			
func _on_body_exited(body):
	if body.is_in_group("Krub"):
		message.hide()
		var krub: Krub= body
		krub.set_near_bucket(false)
		

func add_worm(worm):
	worms.append(worm)
	var worm_node = $Worms.get_node("BucketWorm" + str(worms.size() % 3))
	show_worm(worm_node, worm)

	
func show_worm(worm_sprite: Sprite2D, wormToCopy: Worm):
	var shader_material = wormToCopy.sprite.material.duplicate() as ShaderMaterial
	worm_sprite.material = shader_material
	worm_sprite.show()


func _on_krub_pickup_bucket(krub):
	$Worms/Label.show()	
	message.hide()
	krub.set_bucket(self)
	emit_signal("bucket_picked_up", self)



func _on_body_entered(body):
	if body.is_in_group("Krub"):
		var krub: Krub= body
		message.text = "Pick Up"
		message.show()
		krub.set_near_bucket(true)

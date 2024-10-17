extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D

signal cheeto_ate_worm(worm)
var worm 
func _ready():
	sprite.play("default")
	
func _on_worm_radar_body_entered(body):
	if !worm and body.is_in_group("worm"):
		sprite.play("plunging")
		worm = body
		sprite.z_index = worm.z_index + 1
		$Label.hide()
		emit_signal("cheeto_ate_worm", worm)
		$Timer.start(5)
		


func _on_animated_sprite_2d_animation_finished():
	if 	sprite.animation == "plunging":
		worm == null
		sprite.play("default")
	

func _on_timer_timeout():
	$Label.show()

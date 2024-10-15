extends CanvasLayer

@onready var label = $Control/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	label.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_door_handle_body_entered(body):
	label.visible = true

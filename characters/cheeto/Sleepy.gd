extends Label

@export var delay_time: float = 0.3  # Time delay between text changes
@export var min_font_size: int = 24  # Minimum font size
@export var max_font_size: int = 48  # Maximum font size

var zzz_variants = ["zz", "zzz", "zzzz", "zzzzz", "zzzzzz"]  # Text variants
var index = 0
var expanding = true  # Track if we're expanding or contracting
var tween: Tween

func _ready():
	tween = create_tween().set_loops()
	# Start the first animation with Tween
	animate_text()

# Function to change the text using Tween
func animate_text():
	# Get the current text value
	text = zzz_variants[index]
	# Update the index for expanding/contracting effect
	if expanding:
		index += 1
		if index >= zzz_variants.size():
			index = zzz_variants.size() - 1
			expanding = false
	else:
		index -= 1
		if index <= 0:
			index = 0
			expanding = true


	# Animate the change with Tween
	tween.tween_property(self, "text", zzz_variants[index], delay_time )
	var target_font_size = lerp(min_font_size, max_font_size, float(index) / float(zzz_variants.size() - 1))
	add_theme_font_size_override("font_size", target_font_size)
	# Call the function again after delay_time
	tween.tween_callback(Callable(self, "animate_text"))

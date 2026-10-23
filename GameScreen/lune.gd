extends Area2D

@export var altitude_lune: float = 3000.0
@export var decalage_horizontal: float = 0.0
@export var variation_horizontale: float = 300.0
@export var variation_verticale: float = 500.0


# Called when the node enters the scene tree for the first time.
func _ready():
	
	var fusee = get_parent().get_node("FUSEE")
	var hasard_horizontal = randf_range(-variation_horizontale, variation_horizontale)
	var hasard_vertical = randf_range(-variation_verticale, variation_verticale)
	global_position = fusee.global_position + Vector2(decalage_horizontal + hasard_horizontal, -altitude_lune + hasard_vertical)
	print("Hasard X : ", hasard_horizontal)
	print("Hasard Y : ", hasard_vertical)
	print("Position Lune : ", global_position)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

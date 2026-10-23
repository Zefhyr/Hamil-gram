extends Area2D

@export var taille_min: float = 0.8
@export var taille_max: float = 2
@export var poids_variantes: Array[int] = [25, 25, 20, 15, 8, 5, 2]

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var tirage = randi_range(1, 100)
	var cumul = 0
	var choix = 1

	for index in range(poids_variantes.size()):
		cumul += poids_variantes[index]

		if tirage <= cumul:
			choix = index + 1
			break
	print("Astéroïde choisi : ", choix)
	
	for i in range(1, 8):
		get_node("Sprite" + str(i)).visible = (choix == i)
		get_node("Collision" + str(i)).disabled = (choix != i)
		rotation_degrees = randf_range(-90.0, 90.0)
		var taille = randf_range(taille_min, taille_max)
		scale = Vector2(taille, taille)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

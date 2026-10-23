extends Node2D

const SCENE_OBSTACLE = preload("res://GameScreen/obstacle.tscn")

@export var marge_sol: float = 2000.0
@export var marge_lune: float = 500.0

@export var hauteur_case: float = 800.0
@export var largeur_case: float = 1600.0

@export var largeur_zone: float = 12000.0

@export var obstacles_min: int = 3
@export var obstacles_max: int = 11

@export_range(0.0, 1.0, 0.05) var densite_bords: float = 0.25

@onready var lune = get_parent().get_node("Lune")
@onready var fusee = get_parent().get_node("FUSEE")

var cases: Array[Rect2] = []

func _ready():
	var sprite_lune = lune.get_node("Sprite2D")
	var bas_lune = sprite_lune.global_position.y + sprite_lune.texture.get_height() * abs(sprite_lune.global_scale.y) / 2.0
	
	var y_depart = fusee.global_position.y - marge_sol
	var y_fin = bas_lune + marge_lune
	
	var hauteur_disponible = y_depart - y_fin
	
	var nb_bandes = floori(hauteur_disponible / hauteur_case)
	var nb_colonnes = floori(largeur_zone / largeur_case)
	
	var debut_x = fusee.global_position.x - largeur_zone / 2.0
	
	var debut_generation = Time.get_ticks_msec()
	
	for ligne in range(nb_bandes):
		for colonne in range(nb_colonnes):
			var x = debut_x + colonne * largeur_case
			var y = y_depart - (ligne + 1) * hauteur_case

			var rectangle = Rect2(to_local(Vector2(x, y)),Vector2(largeur_case, hauteur_case))
	
			cases.append(rectangle)
			
	for index in range(cases.size()):
		var rectangle = cases[index]
		var ligne = index / nb_colonnes

		var progression = float(ligne) / maxf(1.0, nb_bandes - 1.0)
		var proximite_centre = 1.0 - abs(2.0 * progression - 1.0)

		var densite = lerpf(densite_bords, 1.0, proximite_centre)
		var quantite = roundi(randi_range(obstacles_min, obstacles_max) * densite)
		
		for i in range(quantite):
			var obstacle = SCENE_OBSTACLE.instantiate()
			obstacle.body_entered.connect(get_parent()._on_obstacle_body_entered)
			
			obstacle.position = Vector2(randf_range(rectangle.position.x, rectangle.end.x),randf_range(rectangle.position.y, rectangle.end.y))
			add_child(obstacle)

	queue_redraw()
	
	print("Bandes : ", nb_bandes)
	print("Colonnes : ", nb_colonnes)
	print("Cases totales : ", nb_bandes * nb_colonnes)


	print("Génération : ", Time.get_ticks_msec() - debut_generation, " ms")


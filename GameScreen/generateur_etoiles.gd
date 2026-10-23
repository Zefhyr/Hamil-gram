extends ParallaxLayer

@export var nombre_etoiles =  180
@export var taille_base = 0.2
@export var modeles_etoiles : Array[Texture2D]

@export var nombre_colonnes = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	
	var nombre_lignes = ceili(float(nombre_etoiles)/nombre_colonnes)
	var taille_ecran = get_viewport_rect().size
	taille_ecran.x *=5
	taille_ecran.y *=5
	var largeur_case = taille_ecran.x/nombre_colonnes
	var hauteur_case = taille_ecran.y/nombre_lignes
	var palette = [Color("ffffff"),
	Color("ffffff"),
	Color("ffffff"),
	Color("ffffff"),
	Color("ffffff"),
	Color("ffffff"),
	Color("59afff"),
	Color("ffffff"),
	Color("ffffff"),
	Color("ffd84d"),
	Color("ffffff"),
	Color("ffffff"),
	Color("ffffff"),
	Color("ffffff"),
	Color("ffffff"),
	Color("ffffff"),
	Color("59afff"),
	Color("ff6b6b"),
	Color("ffd84d"),
	Color("ffd84d")]

	for i in range(nombre_etoiles):
		var colonne = i % nombre_colonnes
		var ligne = int(i/nombre_colonnes)
		var etoile = Sprite2D.new()
		var taille = randf_range(taille_base*0.85, taille_base*1.15)
		
		etoile.rotation_degrees = randf_range(0.0,360.0)
		
		etoile.scale = Vector2(taille,taille)
		
		etoile.texture = modeles_etoiles.pick_random()
		etoile.modulate = palette.pick_random()
		etoile.position = Vector2(colonne * largeur_case +randf_range(0,largeur_case),ligne * hauteur_case +randf_range(0,hauteur_case))
		
		
		
		
		add_child(etoile)
	motion_mirroring = taille_ecran


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	pass

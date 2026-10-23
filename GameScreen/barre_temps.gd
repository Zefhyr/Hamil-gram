extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass
	
func _draw():
	
	var jeu = get_tree().current_scene
	var total = jeu.calculer_duree_totale()
	
	if total > 0:
		var progression = jeu.temps_vol / total
		draw_rect(Rect2(0, 0, size.x * progression, size.y/2), Color("#2878B5"))
	
		var fin_securite = min(jeu.temps_vol + 3.0, total)
		var debut_x = size.x * progression
		var fin_x = size.x * (fin_securite / total)
	
		draw_rect(Rect2(debut_x, 0, fin_x - debut_x, size.y/2), Color("#E8A43D"))

	draw_rect(Rect2(0, 0, size.x, size.y / 2.0), Color("#8FA69A"), false, 1.0)

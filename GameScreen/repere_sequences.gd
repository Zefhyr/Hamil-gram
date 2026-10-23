extends Control



# Called when the node enters the scene tree for the first time.
func _draw():
	
	draw_line(Vector2(0, 20), Vector2(size.x, 20), Color(0.27, 0.30, 0.28), 5.0)
	
	var jeu = get_tree().current_scene
	var total = jeu.calculer_duree_totale()
	
	for seconde in range(5, int(total) + 1, 5):
		var position_x = (seconde / total) * size.x
		draw_line(Vector2(position_x, 12), Vector2(position_x, 28), Color("#2878B5"), 3.0)
		
	if total > 0.0:
		var liste = jeu.get_node("UI/PanelContainer/Console/ZoneProgramme/Carrousel/ListeSequences")
		var debut_sequence = 0.0
		var numero_sequence = 1

		for sequence in liste.get_children():
			var position_x = (debut_sequence / total) * size.x
			draw_line(Vector2(position_x, 6), Vector2(position_x, 22), Color("#38A169"), 3.0)
			draw_string(get_theme_default_font(), Vector2(position_x + 5, 14), "S" + str(numero_sequence), HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color("#38A169"))

			var duree = sequence.get_node("Contenu/DureeSequence/TempsSequence").value
			debut_sequence += duree
			numero_sequence += 1
	
	
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



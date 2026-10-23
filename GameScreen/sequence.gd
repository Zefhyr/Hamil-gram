extends PanelContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_supprimer_pressed():
	
	var liste = get_parent()
	var jeu = get_tree().current_scene
	
	liste.remove_child(self)
	
	queue_free()
	
	jeu.renumeroter_sequences()
	
	jeu.get_node("UI/PanelContainer/Console/ZoneProgramme/BarresTemps/RepereSequences").queue_redraw()

func verrouiller():
	get_node("Contenu/DureeSequence/TempsSequence").editable = false
	get_node("Contenu/Parametres/SpinPoussée").editable = false
	get_node("Contenu/Parametres/SpinPuissance").editable = false
	get_node("Contenu/Parametres/SpinRotation").editable = false
	get_node("Contenu/Parametres/SpinVirage").editable = false
	get_node("Contenu/Entete/Supprimer").disabled = true
	
func deverrouiller():
	get_node("Contenu/DureeSequence/TempsSequence").editable = true
	get_node("Contenu/Parametres/SpinPoussée").editable = true
	get_node("Contenu/Parametres/SpinPuissance").editable = true
	get_node("Contenu/Parametres/SpinRotation").editable = true
	get_node("Contenu/Parametres/SpinVirage").editable = true
	get_node("Contenu/Entete/Supprimer").disabled = false


func _on_temps_sequence_value_changed(value):
	var jeu = get_tree().current_scene
	jeu.get_node("UI/PanelContainer/Console/ZoneProgramme/BarresTemps/RepereSequences").queue_redraw()
	

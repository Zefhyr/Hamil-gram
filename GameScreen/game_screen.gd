extends Node2D

var temps_ecoule = 0.0
var temps_vol = 0.0
var programme_actif = false
var duree_sequence = 0.0
var duree_poussee = 0.0
var angle_rotation = 0.0
var duree_virage = 0.0

var index_sequence = 0

var reprogrammation_active = false
var nb_reprogrammations = 0
var nb_reinitialisations = 0

var collision_en_cours = false

@onready var position_initiale = $FUSEE.global_position
@onready var rotation_initiale = $FUSEE.global_rotation


# Called when the node enters the scene tree for the first time.
func _ready():
	
	recaler_parallaxe()

func _process(delta):
	
	var camera = get_node("FUSEE/Camera2D")
	
	var direction = Input.get_vector("camera_gauche","camera_droite","camera_haut","camera_bas")
	var vitesse_camera = 800.00
	
	camera.offset += direction*vitesse_camera*delta
	
	camera.offset.x = clampf(camera.offset.x,-500.00,500.00)
	camera.offset.y = minf(camera.offset.y,250)

func _on_ajouter_sequence_pressed():
	
	var modele_sequence = load("res://GameScreen/sequence.tscn")
	
	var nouvelle_sequence = modele_sequence.instantiate()
	
	var liste = get_node("UI/PanelContainer/Console/ZoneProgramme/Carrousel/ListeSequences")
	
	liste.add_child(nouvelle_sequence)
	if reprogrammation_active:
		nouvelle_sequence.self_modulate = Color(0.75, 1.0, 0.75)
	
	renumeroter_sequences()
	get_node("UI/PanelContainer/Console/ZoneProgramme/BarresTemps/RepereSequences").queue_redraw()
	get_node("UI/PanelContainer/Console/ZoneProgramme/BarresTemps/BarreTemps").queue_redraw()

func renumeroter_sequences():
	
	var liste = get_node("UI/PanelContainer/Console/ZoneProgramme/Carrousel/ListeSequences")
	
	var sequences = liste.get_children()
	
	for sequence in sequences:
		var titre = sequence.get_node("Contenu/Entete/Titre")
		var numero = sequence.get_index()+1
		titre.text = "SEQUENCE "+str(numero)

func _on_lancement_pressed():
	
	
	temps_vol = 0.0
	var liste = get_node ("UI/PanelContainer/Console/ZoneProgramme/Carrousel/ListeSequences")
	
	get_node("UI/PanelContainer/Console/ZoneProgramme/BarresTemps/RepereSequences").queue_redraw()
	get_node("UI/PanelContainer/Console/Commandes/LANCEMENT").disabled = true
	get_node("UI/PanelContainer/Console/Commandes/AjouterSequence").disabled = true
	get_node("UI/PanelContainer/Console/Commandes/Reprogrammer").disabled = false
		
	for sequence in liste.get_children():
		sequence.verrouiller()
	
	if liste.get_child_count()==0:
		return
		
	temps_ecoule = 0.0
	programme_actif = true
	
	index_sequence = 0
	
	charger_sequence()

func _physics_process(delta):
	
	if programme_actif and not reprogrammation_active:
		
		temps_ecoule+=delta
		temps_vol +=delta
		get_node("UI/PanelContainer/Console/ZoneProgramme/BarresTemps/BarreTemps").queue_redraw()
		
		var minutes = int(temps_vol / 60.0)
		var secondes = fmod(temps_vol, 60.0)
		get_node("UI/PanelContainer/Console/InfosVol/TempsVol").text = "TEMPS :\n%02d:%04.1f" % [minutes, secondes]
		
		var fusee = get_node("FUSEE")
		
		if temps_ecoule<duree_poussee:
			fusee.moteur_actif = true
		else:
			fusee.moteur_actif = false
		
		if duree_virage>0 and temps_ecoule<duree_virage:
			var vitesse_rotation = deg_to_rad(angle_rotation)/duree_virage
			
			fusee.angular_velocity = vitesse_rotation
		else:
			fusee.angular_velocity = 0.0
		
		if temps_ecoule>=duree_sequence:
			programme_actif = false
			fusee.moteur_actif = false
			fusee.angular_velocity = 0.0
			index_sequence +=1
			charger_sequence()
			
			print("SEQUENCE TERMINEE !")
			print(index_sequence)

func charger_sequence():
	var liste = get_node("UI/PanelContainer/Console/ZoneProgramme/Carrousel/ListeSequences")
	var fusee = get_node("FUSEE")

	if index_sequence >= liste.get_child_count():
		programme_actif = false
		fusee.moteur_actif = false
		fusee.angular_velocity = 0.0
		print("PROGRAMME TERMINÉ !")
		return

	var sequence = liste.get_child(index_sequence)

	duree_sequence = sequence.get_node("Contenu/DureeSequence/TempsSequence").value
	duree_poussee = sequence.get_node("Contenu/Parametres/SpinPoussée").value
	var puissance = sequence.get_node("Contenu/Parametres/SpinPuissance").value
	angle_rotation = sequence.get_node("Contenu/Parametres/SpinRotation").value
	duree_virage = sequence.get_node("Contenu/Parametres/SpinVirage").value

	fusee.pourcentage_puissance = puissance
	fusee.moteur_actif = false
	fusee.angular_velocity = 0.0

	temps_ecoule = 0.0
	programme_actif = true

	print("DÉBUT SÉQUENCE ", index_sequence + 1)

func _on_quitter_pressed():
	
	get_tree().change_scene_to_file("res://GameScreen/main_menu.tscn")

func _on_reinit_pressed():
	
	programme_actif = false
	temps_ecoule = 0.0
	index_sequence = 0
	nb_reinitialisations += 1

	get_node("UI/PanelContainer/Console/InfosVol/NbReinitialisations").text = "RÉINIT :\n" + str(nb_reinitialisations)
	get_node("FUSEE").freeze = false
	
	var fusee = get_node("FUSEE")
	
	fusee.moteur_actif = false
	fusee.pourcentage_puissance = 0.0
	
	fusee.linear_velocity = Vector2.ZERO
	fusee.angular_velocity = 0.0	
	fusee.gravity_scale = 1.0
	var depart = Transform2D(rotation_initiale, position_initiale)
	fusee.global_transform = depart
	PhysicsServer2D.body_set_state(fusee.get_rid(), PhysicsServer2D.BODY_STATE_TRANSFORM, depart)
	fusee.sleeping = false
	
	var liste = get_node ("UI/PanelContainer/Console/ZoneProgramme/Carrousel/ListeSequences")
	for sequence in liste.get_children():
		sequence.deverrouiller()
		sequence.self_modulate = Color(1, 1, 1)
		
	get_node("UI/PanelContainer/Console/Commandes/LANCEMENT").disabled = false
	get_node("UI/PanelContainer/Console/Commandes/AjouterSequence").disabled = false
	get_node("UI/PanelContainer/Console/Commandes/Reprogrammer").disabled = true
	
	reprogrammation_active = false
	get_node("UI/PanelContainer/Console/Commandes/Reprogrammer").text = "Hamilt-Off"
	get_node("UI/PanelContainer/Console/Commandes/Reprogrammer").self_modulate = Color(1.0, 1.0, 1.0)
	get_node("UI/PanelContainer/Console/ZoneProgramme/BarresTemps/BarreTemps").queue_redraw()
	get_node("UI/PanelContainer/Console/InfosVol/TempsVol").text = "TEMPS : \n 00:00.0"
	nb_reprogrammations = 0
	get_node("UI/PanelContainer/Console/InfosVol/NbReprogrammations").text = "HAMILT-ON :\n" + str(nb_reprogrammations)
	
	collision_en_cours = false
	$UI/GameOver.hide()
	$UI/Victory.hide()
	$UI/VictoireParfaite.hide()
	$UI/VictoireUltime.hide()
	$Explosion.hide()

	temps_vol = 0.0
	
	print("FUSÉE RÉINITIALISÉE !")

func _unhandled_input(event):
	
	var camera = get_node("FUSEE/Camera2D")
	
	if event is InputEventMouseButton:
		
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			camera.zoom *= 1.1
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			camera.zoom *= 0.9

		
		camera.zoom = camera.zoom.clamp(Vector2(0.25,0.25),Vector2(1,1))
		recaler_parallaxe()

func _on_reprogrammer_pressed():
	
	reprogrammation_active = not reprogrammation_active
	get_node("FUSEE").freeze = reprogrammation_active
	
	if reprogrammation_active:
		
		nb_reprogrammations += 1
		get_node("UI/PanelContainer/Console/InfosVol/NbReprogrammations").text = "HAMILT-ON : \n" + str(nb_reprogrammations)
		var liste = get_node("UI/PanelContainer/Console/ZoneProgramme/Carrousel/ListeSequences")
		var debut_sequence = 0.0
		var horizon_securite = temps_vol + 3.0
		print("Horizon de sécurité : ", horizon_securite)
		
		for sequence in liste.get_children():
			print("Début : ", debut_sequence)
			
			if debut_sequence >= horizon_securite:
				get_node("UI/PanelContainer/Console/Commandes/AjouterSequence").disabled = false
			else:
				get_node("UI/PanelContainer/Console/Commandes/AjouterSequence").disabled = true
				
			if debut_sequence >= horizon_securite:
				sequence.deverrouiller()
				sequence.self_modulate = Color(0.75, 1.0, 0.75)
			else:
				sequence.verrouiller()
				sequence.self_modulate = Color(1.0, 0.75, 0.75)
				
			var duree = sequence.get_node("Contenu/DureeSequence/TempsSequence").value
			debut_sequence += duree
		
		get_node("UI/PanelContainer/Console/Commandes/Reprogrammer").text = "Hamilt-On"
		get_node("UI/PanelContainer/Console/Commandes/Reprogrammer").self_modulate = Color(0.75, 1.0, 0.75)
		

	else:
		get_node("UI/PanelContainer/Console/Commandes/Reprogrammer").text = "Hamilt-Off"
		get_node("UI/PanelContainer/Console/Commandes/AjouterSequence").disabled = true
		get_node("UI/PanelContainer/Console/Commandes/Reprogrammer").self_modulate = Color(1, 1, 1)
		var liste = get_node("UI/PanelContainer/Console/ZoneProgramme/Carrousel/ListeSequences")
		for sequence in liste.get_children():
			sequence.verrouiller()
			sequence.self_modulate = Color(1, 1, 1)
			
	print(reprogrammation_active)

func _on_recentrer_fusee_pressed():
	
	get_node("FUSEE/Camera2D").offset = Vector2.ZERO
	
func _on_recentrer_fusee_mouse_entered():
	
	get_node("UI/PanelContainer/Console/InfosVol/RecentrerFusee").self_modulate = Color(0.75, 1.0, 0.75)

func _on_recentrer_fusee_mouse_exited():
	
		get_node("UI/PanelContainer/Console/InfosVol/RecentrerFusee").self_modulate = Color(1, 1, 1)

func calculer_duree_totale():
	
	var total = 0.0
	var liste = get_node("UI/PanelContainer/Console/ZoneProgramme/Carrousel/ListeSequences")
		
	for sequence in liste.get_children():
		var duree = sequence.get_node("Contenu/DureeSequence/TempsSequence").value
		total += duree
		
	return total

func recaler_parallaxe():
	var camera = get_node("FUSEE/Camera2D")
	var fond = get_node("FondEtoile")
	var correction_zoom = 1.0 / camera.zoom.x
	var centre_ecran = get_viewport_rect().size / 2.0

	for couche in fond.get_children():
		couche.motion_offset = centre_ecran * (Vector2.ONE - couche.motion_scale) * correction_zoom

func _on_obstacle_body_entered(body: Node2D):
	if body != $FUSEE or collision_en_cours:
		return

	collision_en_cours = true
	programme_actif = false

	$FUSEE.moteur_actif = false
	$FUSEE.set_deferred("freeze", true)

	$Explosion.global_position = $FUSEE.global_position
	$Explosion.show()

	await get_tree().create_timer(0.66).timeout

	if not collision_en_cours:
		return

	$UI/GameOver.show()

func _on_reessayer_pressed():
	
	$UI/GameOver.hide()
	$UI/Victory.hide()
	_on_reinit_pressed()

func _on_abandonner_pressed():
	
	get_tree().change_scene_to_file("res://GameScreen/main_menu.tscn")

func _on_lune_body_entered(body: Node2D):
	if body != $FUSEE or collision_en_cours:
		return

	collision_en_cours = true
	programme_actif = false

	$FUSEE.moteur_actif = false
	$FUSEE.set_deferred("freeze", true)

	if nb_reinitialisations == 0 and nb_reprogrammations == 0:
		$UI/VictoireUltime.show()
	elif nb_reinitialisations == 0:
		$UI/VictoireParfaite.show()
	else:
		$UI/Victoire.show()

func _unhandled_key_input(event: InputEvent):
	if event.is_action_pressed("hamilt_toggle") and not event.is_echo():
		var bouton = $UI/PanelContainer/Console/Commandes/Reprogrammer

		if not bouton.disabled:
			_on_reprogrammer_pressed()
			get_viewport().set_input_as_handled()

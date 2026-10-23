extends RigidBody2D

var puissance_moteur = 2000
var pourcentage_puissance = 0.0
var moteur_actif = false

const ALTITUDE_MAX = 2000.0

@onready var altitude_depart = global_position.y

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$EffetPoussee.visible = moteur_actif and not freeze
	$EffetGauche.visible = angular_velocity < -0.01 and not freeze
	$EffetDroite.visible = angular_velocity > 0.01 and not freeze


func _physics_process(delta):
	
	var altitude = max(0.0, altitude_depart - global_position.y)

	gravity_scale = clampf(1.0 - altitude / ALTITUDE_MAX, 0.0, 1.0)

	if moteur_actif and not freeze:
		var direction = -transform.y
		var force = direction*puissance_moteur*(pourcentage_puissance/100)
		
		apply_central_force(force)
		
		
	

extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	var bus = AudioServer.get_bus_index("Master")
	var volume = db_to_linear(AudioServer.get_bus_volume_db(bus))

	$CenterContainer/VBoxContainer/HBoxContainer/HSlider.set_value_no_signal(volume * 100.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	
	get_tree().change_scene_to_file("res://GameScreen/game_screen.tscn")


func _on_button_quitter_pressed():
	
	get_tree().quit()


func _on_h_slider_value_changed(value):
	
	var volume = value/100;
	AudioServer.set_bus_volume_db(0,linear_to_db(volume));

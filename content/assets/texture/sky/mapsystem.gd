extends Node3D



func _process(delta):
	$WorldEnvironment.environment.background_sky_rotation_degrees.y -= 0.025

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("F5"):
		get_tree().reload_current_scene()


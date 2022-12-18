extends Spatial

var mouse_on_button = false

func _on_StaticBody_mouse_entered():
	mouse_on_button = true

func _on_StaticBody_mouse_exited():
	mouse_on_button = false

func _physics_process(delta):
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
	if Input.is_action_just_pressed("click") and mouse_on_button:
		get_tree().change_scene("res://Main.tscn")

extends Spatial

onready var Score_P1 = $UI/Score_P1
onready var Score_P2 = $UI/Score_P2
onready var environment = $Environment/WorldEnvironment
var env_low = preload("res://default_env.tres")
var env_high = preload("res://high_env.tres")

func _physics_process(delta):
	Score_P1.set_text(str(Log.Score_P1))
	Score_P2.set_text(str(Log.Score_P2))
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
func _on_Fallzone_body_entered(body):
	if body.is_in_group("P1"):
		Log.Score_P2 = Log.Score_P2 + 1
		get_tree().reload_current_scene()
	if body.is_in_group("P2"):
		Log.Score_P1 = Log.Score_P1 + 1
		get_tree().reload_current_scene()

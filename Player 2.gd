extends RigidBody

onready var particles = $Particles
onready var animation = $Bob/AnimationPlayer
onready var stomp_1 = $Stomp
onready var stomp_2 = $Stomp2
var direction = "left"
signal Hit
signal Stomp
var reload_time = 0
var duble_jump = false
var stomp = false
var stomping = false

func _physics_process(delta):
	
	var dir = Vector3()
	Log.Pos_P2 = global_transform.origin
	var space_state = get_world().direct_space_state

	if get_linear_velocity().x <= 5 and get_linear_velocity().x >= -5:
		dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
		
	if Input.is_action_just_pressed("ui_up"):
		if duble_jump:
			apply_central_impulse(Vector3(0,12,0))
			set_rotation_degrees(Vector3(0,0,0))
			duble_jump = false
		elif get_linear_velocity().y <= 0.1 and get_linear_velocity().y >= -0.1:
			apply_central_impulse(Vector3(0,8,0))
			set_rotation_degrees(Vector3(0,0,0))
			duble_jump = true
		
	if Input.is_action_just_pressed("rshift") and reload_time <= 0:
		reload_time = 60
		if direction == "right":
			particles.set_rotation_degrees(Vector3(0,-90,0))
			particles.set_emitting(true)
			if (Log.Pos_P1.x - Log.Pos_P2.x) <= 3 and particles.is_emitting() and Log.Pos_P1.x >= Log.Pos_P2.x: 
				emit_signal("Hit")
		if direction == "left":
			particles.set_rotation_degrees(Vector3(0,90,0))
			particles.set_emitting(true)
			if (Log.Pos_P1.x - Log.Pos_P2.x) >= -3 and particles.is_emitting() and Log.Pos_P1.x <= Log.Pos_P2.x: 
				emit_signal("Hit")
				
	if get_linear_velocity().y <= 9 and get_linear_velocity().y >= -9 and stomp:
		stomp = false
	else:
		stomp = true
	if stomp and Input.is_action_pressed("ui_down") and Input.is_action_just_pressed("special_2"):
		apply_impulse(Log.Pos_P2, Vector3(0,-10,0))
		stomp = false
		stomping = true
		
	if Input.is_action_pressed("ui_right"):
		direction = "right"
		animation.play("walk_right")
	if Input.is_action_pressed("ui_left"):
		direction = "left"
		animation.play("walk_left")
	if not Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left"):
		if direction == "left":
			animation.play("idle_left")
		if direction == "right":
			animation.play("idle_right")
			
	reload_time = reload_time - 1
	
	#print(str(stomp))
		
	apply_central_impulse(dir.normalized())


func _on_Player_1_Hit():
	apply_impulse(Log.Pos_P1, Vector3((Log.Pos_P2.x - Log.Pos_P1.x) * 2,10,0))
	
func _on_Player_1_Stomp():
	apply_impulse(Log.Pos_P1, Vector3((Log.Pos_P2.x - Log.Pos_P1.x)/2,15,0))

func _on_Area_body_entered(body):
	if not body.is_in_group("P2"):
		if stomping:
			stomp_1.set_emitting(true)
			stomp_2.set_emitting(true)
			stomping = false
			if Log.Pos_P2.x >= Log.Pos_P1.x and (Log.Pos_P1.x - Log.Pos_P2.x) >= -3:
				emit_signal("Stomp")
			elif Log.Pos_P2.x <= Log.Pos_P1.x and (Log.Pos_P1.x - Log.Pos_P2.x) <= 3:
				emit_signal("Stomp")



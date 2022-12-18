extends RigidBody

onready var punch = $Punch
onready var animation = $Bobi/AnimationPlayer
onready var stomp_1 = $Stomp
onready var stomp_2 = $Stomp2
var direction = "right"
signal Hit
signal Stomp
var reload_time = 0
var duble_jump = false
var stomp = false
var stomping = false

func _physics_process(delta):

	Log.Pos_P1 = global_transform.origin
	
	var space_state = get_world().direct_space_state
	var dir = Vector3()
	
	if get_linear_velocity().x <= 10 and get_linear_velocity().x >= -10:
		dir.x = Input.get_action_strength("d") - Input.get_action_strength("a")
	
	if Input.is_action_just_pressed("w"):
		if duble_jump:
			apply_central_impulse(Vector3(0,12,0))
			set_rotation_degrees(Vector3(0,0,0))
			duble_jump = false
		elif get_linear_velocity().y <= 0.1 and get_linear_velocity().y >= -0.1:
			apply_central_impulse(Vector3(0,8,0))
			set_rotation_degrees(Vector3(0,0,0))
			duble_jump = true
		
	if Input.is_action_just_pressed("space") and reload_time <= 0:
		reload_time = 60
		if direction == "right":
			punch.set_rotation_degrees(Vector3(0,-90,0))
			punch.set_emitting(true)
			if (Log.Pos_P2.x - Log.Pos_P1.x) <= 3 and punch.is_emitting() and Log.Pos_P2.x >= Log.Pos_P1.x: 
				emit_signal("Hit")
		if direction == "left":
			punch.set_rotation_degrees(Vector3(0,90,0))
			punch.set_emitting(true)
			if (Log.Pos_P2.x - Log.Pos_P1.x) >= -3 and punch.is_emitting() and Log.Pos_P2.x <= Log.Pos_P1.x: 
				emit_signal("Hit")
				
	if get_linear_velocity().y <= 0.1 and get_linear_velocity().y >= -0.1:
		stomp = false
	else:
		stomp = true
		
	if Input.is_action_pressed("s"):
		if Input.is_action_just_pressed("special_1"):
			apply_impulse(Log.Pos_P1, Vector3(0,-10,0))
			stomp = false
			stomping = true
		
	if Input.is_action_pressed("d"):
		direction = "right"
		animation.play("walk_right")
	if Input.is_action_pressed("a"):
		direction = "left"
		animation.play("walk_left")
	if not Input.is_action_pressed("a") and not Input.is_action_pressed("d"):
		if direction == "left":
			animation.play("idle_left")
		if direction == "right":
			animation.play("idle_right")
	
	reload_time = reload_time - 1
	
	apply_central_impulse(dir.normalized())
		
func _on_Player_2_Hit():
	apply_impulse(Log.Pos_P2, Vector3((Log.Pos_P1.x - Log.Pos_P2.x) * 8,10,0))

func _on_Area_body_entered(body):
	if not body.is_in_group("P1"):
		if stomping:
			stomp_1.set_emitting(true)
			stomp_2.set_emitting(true)
			stomping = false
			if Log.Pos_P1.x >= Log.Pos_P2.x and (Log.Pos_P2.x - Log.Pos_P1.x) >= -3:
				emit_signal("Stomp")
			elif Log.Pos_P1.x <= Log.Pos_P2.x and (Log.Pos_P2.x - Log.Pos_P1.x) <= 3:
				emit_signal("Stomp")
				
func _on_Player_2_Stomp():
	apply_impulse(Log.Pos_P1, Vector3((Log.Pos_P1.x - Log.Pos_P2.x)/2,15,0))


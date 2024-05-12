extends CharacterBody3D

@onready var HEAD = $Head
@onready var JUMP_BTN = $"../JumpBtn"
@onready var RUN_BTN = $"../RunBtn"

const SENSITIVITY = 0.13
var RUN_BTN_MODE = false
var SPEED = 4.0
const JUMP_VELOCITY = 4.5

const lerp_time = 10
var direction = Vector3.ZERO

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var piso=true


func _input(event):
	if event is InputEventScreenDrag:
		if event.position.x > 400:
			rotate_y(deg_to_rad(-event.relative.x * SENSITIVITY))
			HEAD.rotate_x(deg_to_rad(-event.relative.y * SENSITIVITY))
		
			HEAD.rotation.x = clamp(HEAD.rotation.x, deg_to_rad(-80), deg_to_rad(60))
		
func _physics_process(delta):
	var character_position = global_transform.origin.y
	var character_positionX = global_transform.origin.x
	var character_positionz = global_transform.origin.z
	
	if character_position > 6.80:
		velocity.y -= gravity * delta
		piso=false
		printerr(character_position)
	else:
		piso=true
		printerr(character_position)
		
	if (Input.is_action_just_pressed("ui_accept") or JUMP_BTN.is_pressed()) and piso:
		velocity.y = JUMP_VELOCITY
		piso=false
		printerr(piso)
	

	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if RUN_BTN.is_pressed():
		input_dir.y = -1
		SPEED = 8.0
	else:
		SPEED = 4.0
		
		
	direction = lerp(direction, (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(), delta * lerp_time)
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	print(character_positionX)
	print("a")
	print(character_positionz)
	if character_positionX < 10.10:
		# Verificar la dirección del movimiento antes de ajustar la velocidad horizontal
		if direction.x < 0:
			velocity.x = 0
			
	elif character_positionX > 18.30:
		if direction.x > 0:
			velocity.x = 0
			
	print(character_positionz)
	if character_positionz < -35.90:
		# Verificar la dirección del movimiento antes de ajustar la velocidad horizontal
		if direction.z < 0:
			velocity.z = 0
			
	elif character_positionz > -25.70:
		if direction.z > 0:
			velocity.z = 0
			
	if(!piso and character_position>7.90):
		velocity.y=-20

	move_and_slide()

	
	
	

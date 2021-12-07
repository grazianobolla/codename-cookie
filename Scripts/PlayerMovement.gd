extends Node

export(float) var WALK_SPEED = 3
export(float) var RUN_SPEED = 7
export(float) var ACCELERATION_SPEED = 8
export(float) var DEACCELERATION_SPEED = 12
export(float) var JUMP_FORCE = 15
export(float) var GRAVITY_FORCE = 40
export(float) var ROTATION_SPEED = 10

onready var anim_tree = $"../AnimationTree"
onready var kinematic_body = $"../"
onready var model_mesh = $"../Mesh"
onready var player = get_parent()

#input
var input_data: InputData = InputData.new()

#movement
var input_direction: Vector2
var forward_direction: Vector3
var velocity: Vector3
var current_speed: float = WALK_SPEED

func _physics_process(delta):
	#if any player enters a dialog, inputs are locked
	if DialogSystem.is_active:
		input_data.zero()

	_calculate_input()
	_calculate_movement(delta)
	_calculate_animations(delta)

func _input(event):
	#reads input and updates _input_data accordingly
	if event.device != player.device_id:
		return

	if event is InputEventJoypadMotion:
		if event.axis == JOY_ANALOG_LX:
			input_data.raw_movement_input.x = event.axis_value
		if event.axis == JOY_ANALOG_LY:
			input_data.raw_movement_input.y = event.axis_value

	if event is InputEventJoypadButton:
		input_data.jump_key = event.is_action_pressed("a")
		
		if event.button_index == JOY_R2:
			input_data.run_key = event.pressed

func _calculate_input():
	input_direction = _map_joy_input(input_data.raw_movement_input, 0.2) #TODO: magic numbers
	current_speed = WALK_SPEED if !input_data.run_key else RUN_SPEED

#maps raw axis input to a circle that respects the dead zone
func _map_joy_input(raw_data: Vector2, dead_zone: float) -> Vector2:
	var length = raw_data.length()
	if length < dead_zone:
		return Vector2()
	elif length > 1:
		return raw_data.normalized()
	else:
		return raw_data * (inverse_lerp(dead_zone, 1, length) / length)

func _calculate_movement(delta):
	#calculate forward direction based on camera rotation
	if input_direction.length() > 0:
		forward_direction = Vector3(input_direction.x, 0, input_direction.y).normalized()
		#forward_direction = forward_direction.rotated(Vector3.UP, camera.global_transform.basis.get_euler().y).normalized()

	#move forward, excluding Y axis
	var lateral_velocity = velocity
	lateral_velocity.y = 0

	if input_direction.length() != 0:
		lateral_velocity = lateral_velocity.linear_interpolate(forward_direction * current_speed * input_direction.length(), ACCELERATION_SPEED * delta)
	elif kinematic_body.is_on_floor():
		lateral_velocity = lateral_velocity.linear_interpolate(Vector3.ZERO, DEACCELERATION_SPEED * delta)

	#apply gravity
	velocity.y -= GRAVITY_FORCE * delta

	if input_data.jump_key and kinematic_body.is_on_floor():
		velocity.y = JUMP_FORCE

	velocity.x = lateral_velocity.x
	velocity.z = lateral_velocity.z

	#move
	velocity = kinematic_body.move_and_slide(velocity, Vector3.UP)

func _calculate_animations(delta):
	#rotate mesh
	if input_direction.length() > 0:
		var angle = Vector2(forward_direction.z, forward_direction.x).angle()
		var target_quat = Quat(model_mesh.transform.basis.rotated(Vector3.UP, angle - model_mesh.rotation.y))
		model_mesh.transform.basis = Basis(Quat(model_mesh.transform.basis).slerp(target_quat, delta * ROTATION_SPEED))

	var length: float = input_direction.length()

	anim_tree["parameters/MoveBlend/blend_amount"] = 1.0 if length > 0.8 else length #TODO: magic numbers
	if !anim_tree["parameters/JumpShot/active"]:
		anim_tree["parameters/JumpShot/active"] = input_data.jump_key

	anim_tree["parameters/WalkSpeed/scale"] = 1.3 if !input_data.run_key else 2.0 #TODO: magic numbers

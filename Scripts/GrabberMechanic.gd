extends Node

export(NodePath) var grabbing_area
export(NodePath) var prop_origin

onready var player = get_parent()
onready var area: Area = get_node(grabbing_area)
onready var origin: Spatial = get_node(prop_origin)

var current_object: Prop = null

func _input(event):
	if event.device != player.device_id:
		return

	if event is InputEventJoypadButton:
		if event.button_index == JOY_XBOX_X and event.pressed:
			if current_object == null:
				grab()
			else:
				drop()
	
func grab():
	if current_object != null:
		return

	var arr = area.get_overlapping_bodies()

	for body in arr:
		if body.is_in_group("prop"):
			#disable collisions
			body.set_collision_mask(0)
			body.set_collision_layer(0)

			#disable gravity
			body.gravity_scale = 0

			#set all rigidbody velocities to 0
			body.linear_velocity = Vector3.ZERO
			body.angular_velocity = Vector3.ZERO

			#change parent to player
			body.get_parent().remove_child(body)
			origin.add_child(body)

			#set position
			body.global_transform = origin.global_transform
			
			#assing new node
			current_object = body
			return
			
func drop():
	if current_object == null:
		return

	#change parent to world
	current_object.get_parent().remove_child(current_object)
	current_object.default_parent.add_child(current_object)

	#set position
	current_object.global_transform = origin.global_transform

	#enable collisions
	current_object.set_collision_mask(3)
	current_object.set_collision_layer(3)
	
	#enable gravity
	current_object.gravity_scale = 1
	
	#reset velocity (just in case)
	current_object.linear_velocity = Vector3.ZERO
	current_object.angular_velocity = Vector3.ZERO

	#assing null to current object
	current_object = null

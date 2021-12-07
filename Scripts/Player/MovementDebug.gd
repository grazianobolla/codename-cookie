extends Node2D

onready var player_movement = $"../PlayerMovement"
onready var player = get_parent()

func _physics_process(_delta):
	position = Vector2(position.x, 64 + (192 * player.device_id))
	update()

func _draw():	
	#forward
	draw_line(Vector2.ZERO, Vector2(player_movement.forward_direction.x, player_movement.forward_direction.z) * 64, Color.red, 3)

	#input
	draw_line(Vector2.ZERO, player_movement.input_direction * 64, Color.white, 3)

	#mesh
	draw_line(Vector2.ZERO, Vector2(player_movement.model_mesh.global_transform.basis.z.x, player_movement.model_mesh.global_transform.basis.z.z) * 32, Color.purple, 3)

	#velocity
	draw_circle(Vector2(player_movement.velocity.x, player_movement.velocity.z) * 8, 3, Color.blue)

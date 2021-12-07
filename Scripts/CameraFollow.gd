extends Camera

export(NodePath) onready var scene = get_node(scene) as Node

export(float) var distance_multiplier = 1
export(float) var max_distance = 8
export(float) var min_distance = 5
export(float) var interpolation_speed = 4
export(Vector3) var target_offset = Vector3(0, 1, 0)

var players = []

func _ready():
	for node in scene.get_children():
		if node.is_in_group("player"):
			players.push_back(node)

func _physics_process(delta):
	#calculate average position & angle
	var avg_position: Vector3 = Vector3()

	for p in players:
		avg_position += p.global_transform.origin

	avg_position /= players.size()

	#calculate average distance of players from average point
	var avg_distance: float = 0
	for p in players:
		avg_distance += (p.global_transform.origin).distance_to(avg_position)
	
	avg_distance /= players.size()

	self.look_at(avg_position, Vector3.UP)
	
	var distance = (distance_multiplier * avg_distance)
	distance = clamp(distance, min_distance, max_distance)

	var angle: float = PI/2
	var target: Vector3 = avg_position + Vector3(cos(angle), 1, sin(angle)) * distance
	target += target_offset
	
	self.global_transform.origin = self.global_transform.origin.linear_interpolate(target, delta * interpolation_speed)

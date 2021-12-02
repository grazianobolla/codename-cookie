extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area_body_entered(body:Node):
	if body.is_in_group("player"):
		DialogSystem.get_in_queue("Fuck this crap!Fuck this crap!Fuck this crap!Fuck this crap!Fuck this crap!Fuck this crap!Fuck this crap!Fuck this crap!Fuck this crap!Fuck this crap!", body)
		DialogSystem.get_in_queue("Fuck this crap!Fuck this crap!Fuck this crap!Fuck this crap!Fuck this crap!Fuck this crap!Fuck this crap!Fuck this crap!Fuck this crap!Fuck this crap!", body)
		DialogSystem.get_in_queue("Fuck this crap!Fuck this crap!Fuck this crap!Fuck this crap!Fuck this crap!Fuck this crap!Fuck this crap!Fuck this crap!Fuck this crap!Fuck this crap!", body)

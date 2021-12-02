extends KinematicBody

var device_id: int = -1

func _ready():
	device_id = JoystickManager.assign_aviable_joystick_id()
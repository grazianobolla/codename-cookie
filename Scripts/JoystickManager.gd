extends Node

var connected_joys = []

func assign_aviable_joystick_id() -> int:
    for joy_id in Input.get_connected_joypads():
        if !connected_joys.has(joy_id):
            connected_joys.push_back(joy_id)
            return joy_id

    return -1
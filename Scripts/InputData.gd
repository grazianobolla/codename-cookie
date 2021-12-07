class_name InputData

var raw_movement_input: Vector2 = Vector2.ZERO
var raw_camera_input: Vector2 = Vector2.ZERO
var jump_key: bool = false
var run_key: bool = false

func zero():
    raw_movement_input = Vector2.ZERO
    raw_camera_input = Vector2.ZERO
    jump_key = false
    run_key = false
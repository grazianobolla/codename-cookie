extends Node
class_name Prop

var default_parent: Node = null

func _ready():
	default_parent = get_parent()
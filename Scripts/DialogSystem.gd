extends Control

signal started()
signal finished()

export(float) var SPEED = 1
onready var text_label = $RichTextLabel

var text: String = ""
var char_count: int = 0
var cooldown: float = 0
var wait_time: float = 0
var is_active: bool = false
var queue = []

func _ready():
	#disable scroll bar
	$RichTextLabel.get_child(0).modulate.a = 0

	#disable the dialog box
	_de_activate(false)

func _process(delta):
	_calculate(delta)

func _calculate(delta):
	cooldown += delta

	if char_count < text.length():
		if Input.is_action_just_pressed("a"):
			_skip()
			return

		if cooldown >= wait_time:
			cooldown = 0
			wait_time = SPEED / 1000.0
			_put_character(char_count)
	else:
		if Input.is_action_just_pressed("a"):
			if !queue.empty():
				_say()
			else:
				_de_activate(true)

#inserts a string into the queue, if the dialog box is open, it will appear as a following message, if the dialog is closed it will be opened
func get_in_queue(param_text: String):
	queue.push_back(param_text)

	if !is_active:
		_activate()
		_say()
	
#skips the writing of a message
func _skip():
	char_count = text.length()
	text_label.text = text

#activates the dialog box
func _activate():
	is_active = true
	self.show()
	set_process(true)
	emit_signal("started")

#deactivates the dialog box
func _de_activate(send_signal: bool):
	is_active = false
	self.hide()
	set_process(false)

	if send_signal:
		emit_signal("finished")
		
#writes a message in the dialog box
func _say():
	text_label.clear()
	text = queue.pop_front()
	char_count = 0
	cooldown = 0

#called when each character is typed
func _put_character(index: int):
	text_label.text += text[index]
	char_count += 1

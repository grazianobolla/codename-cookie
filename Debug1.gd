extends Area

func _on_Area_body_entered(body:Node):
	if body.is_in_group("player"):
		DialogSystem.get_in_queue("Tremendo sistema de dialogos, muy bueno, este es un texto largo.\nWawawawawawawa chupaverga!", body)
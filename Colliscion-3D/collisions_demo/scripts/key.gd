extends Area2D

signal collected

func _on_body_entered(body: Node) -> void:
	collected.emit(body)
	var main = get_tree().get_root().get_node("Main")
	if main and main.has_method("on_key_collected"):
		main.on_key_collected()
	queue_free()

# Sistema de Gema Mística - Por Adrian Coello
extends Area2D

signal collected

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		print("¡Adrián ha encontrado la Gema Mística legendaria!")
	collected.emit(body)
	queue_free()

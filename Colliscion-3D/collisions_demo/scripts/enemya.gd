extends Node2D

@onready var animation_player = $AnimationPlayer
@onready var activate_zone = $ActivateZone
@onready var hitbox = $Hitbox
func _ready() -> void:
	add_to_group("enemies")
	# Asegura que el área detecte la capa 2 (jugador)
	activate_zone.collision_mask = 2
	hitbox.collision_mask = 2


func _on_activate_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		animation_player.play("Active")


var player_in_hitbox = false
var vulnerable = false
var health := 3

func _on_hitbox_body_entered(body: Node) -> void:
	if body.is_in_group("player") and not player_in_hitbox:
		player_in_hitbox = true
		if vulnerable:
			print("¡Enemigo A derrotado por el poder del diamante de Adrián!")
			queue_free()  # Eliminación inmediata con el poder del diamante
			return
		if body.has_method("take_damage"):
			body.take_damage(1)

func set_vulnerable(value: bool) -> void:
	vulnerable = value

func _on_hitbox_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_hitbox = false


func _on_activate_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		animation_player.play("Idle")

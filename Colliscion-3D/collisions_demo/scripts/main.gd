
# Aventura de Adrián - Sistema de Juego Principal
# Desarrollado por: Adrian Coello
# Motor: Godot Engine

extends Node2D

func _on_player_health_changed(new_health):
	player_health_label.text = "Vida Adrián: %d" % new_health

@onready var door: Area2D = $Door
@onready var world = $World

var gem_scene = preload("res://scenes/gem.tscn")
var gem_timer: Timer
var key_collected := false

@onready var player_health_label = $PlayerHealthLabel
@onready var enemya_health_label = $EnemyAHealthLabel
@onready var gem_timer_label = $GemTimerLabel

@onready var player = $Player
@onready var enemya = $World/EnemyA

func _ready() -> void:
	$Key.collected.connect(on_key_collected)

	door.body_entered.connect(_on_door_body_entered)

	var gem = $World/Gem
	gem.collected.connect(_on_gem_collected)

	gem_timer = Timer.new()
	gem_timer.wait_time = 7.0
	gem_timer.one_shot = true
	gem_timer.connect("timeout", Callable(self, "_on_gem_timer_timeout"))
	add_child(gem_timer)

	_update_labels()

	player.health_changed.connect(_on_player_health_changed)

func _on_gem_collected(body):
	print("¡Gema Mística recogida! Adrián tiene poderes especiales por 7 segundos.")
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.set_vulnerable(true)
	gem_timer.start()

	gem_timer_label.visible = true


func _on_gem_timer_timeout():
	print("El poder de la Gema Mística se ha desvanecido.")
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.set_vulnerable(false)

	gem_timer_label.visible = false
func on_key_collected():
	print("¡Llave Dorada obtenida! Ahora puedes abrir la puerta de salida.")
	door.open()
	key_collected = true


func _on_door_body_entered(body):
	if body == player and door.get_node("CollisionShape2D").disabled == false and key_collected:
		print("¡Felicidades Adrián! ¡Has completado la aventura exitosamente!")
		get_tree().quit() # O cambiar de escena si lo deseas


func _update_labels():
	player_health_label.text = "Vida Adrián: %d" % player.health
	enemya_health_label.text = "Enemigo A: %d" % enemya.health
	if gem_timer.is_stopped():
		gem_timer_label.text = "Gema Mística: Inactiva"
	else:
		gem_timer_label.text = "Poder Mágico: %.1fs" % gem_timer.time_left


func _process(delta):
	if gem_timer_label.visible and not gem_timer.is_stopped():
		gem_timer_label.text = "Poder Mágico: %.1fs" % gem_timer.time_left

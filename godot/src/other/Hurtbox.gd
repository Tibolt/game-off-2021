extends Area2D


const hitEffect = preload("res://src/other/HitEffect.tscn")

onready var timer = $Timer
onready var shape = $hutbox_shape
var invincible = false setget set_invincible

signal invincible_started
signal invincible_ended

func set_invincible(value):
	invincible = value
	if invincible:
		emit_signal("invincible_started")
	else:
		emit_signal("invincible_ended")

func start_invicibility(duration):
	self.invincible = true
	timer.start(duration)

func hit_effect():
	var effect = hitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position


func _on_Timer_timeout():
	self.invincible = false


func _on_hurtbox_invincible_started():
	shape.set_deferred("disabled", true)


func _on_hurtbox_invincible_ended():
	shape.disabled = false

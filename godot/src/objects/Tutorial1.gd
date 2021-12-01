extends Node2D

export var hints = 2

onready var tutorial_anim = $tutorial_animation
onready var tutorial_background = $CanvasLayer/tutorial_background

func _process(delta):
	if Input.is_action_just_pressed("l_attack"):
		tutorial_background.visible = false

func _on_tutorial_area_body_entered(body):
	if hints > 0:
		tutorial_anim.play("Show_text")
		hints -= 1

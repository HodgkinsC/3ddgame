extends Area2D

var pressed = false
var obj = 0

@export var doorcollision:Node
@export var doorsprite:Node

func _on_body_entered(body):
	obj += 1

func _on_body_exited(body):
	obj -= 1

func _physics_process(delta):
	if obj > 0:
		pressed = true
	else:
		pressed = false
	doorcollision.disabled = pressed
	doorsprite.visible = !pressed

extends Node2D

const ARROW = preload("res://Scenes/Arrows/BasicArrowProjectile.tscn")
onready var cooldownTimer = get_node("ShootCooldownTimer")
onready var player = get_tree().get_root().get_node("Player1")

var shootVector = Vector2.ZERO 
var shootPower = 500

var disabled = true

func _process(delta):
	if !disabled:
		shootVector = (player.position + Vector2(0, -50) - position).normalized()
		
		if Input.is_action_just_pressed("debug_fire"):
			var arrowInst = ARROW.instance()
			get_parent().add_child(arrowInst)
			arrowInst.position = global_position
			arrowInst.rotation = shootVector.angle()
			arrowInst.launch(shootVector * shootPower, self)

func _on_ShootCooldownTimer_timeout():
	var arrowInst = ARROW.instance()
	get_parent().add_child(arrowInst)
	arrowInst.position = global_position
	arrowInst.rotation = shootVector.angle()
	arrowInst.launch(shootVector * shootPower, self)

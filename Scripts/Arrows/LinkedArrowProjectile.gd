extends "res://Scripts/Arrows/ArrowProjectile.gd"

# onready var linkedArrowProjectile = preload("res://Scenes/Arrows/LinkedArrowProjectile.tscn")

var acceleration = Vector2.ZERO
var target = null
var original = true
var steerForce = 25.0

func _ready():
	mass = 30.0
	ignoreShield = false
	maxBounce = 1
	pass

func handleMovement(delta):
	var steerVel = Vector2.ZERO
	
	if target:
		var targetVel = (target.position - position).normalized() * velocity.length()
		steerVel = (targetVel - velocity).normalized() * steerForce
		
	acceleration += steerVel
	velocity += acceleration * delta
	rotation = velocity.angle()
	position += velocity * delta
	

func onLaunch(vel : Vector2, pos : Vector2, rot : float, origin):
	if original:
		velocity = rotateVector(vel, deg2rad(-10))
		rotation = rot + deg2rad(-10)
		
		var arrowInst = duplicate()
		arrowInst.target = self
		arrowInst.original = false
		arrowInst.applyRecoil = false
		target = arrowInst
		get_tree().get_root().add_child(arrowInst)
		arrowInst.launch(rotateVector(vel, deg2rad(10)), pos, rot + deg2rad(10), origin)
		
		print("launched linked arrow")
	

func rotateVector(vec : Vector2, delta : float):
	return Vector2(vec.x * cos(delta) - vec.y * sin(delta), vec.x * sin(delta) + vec.y * cos(delta))

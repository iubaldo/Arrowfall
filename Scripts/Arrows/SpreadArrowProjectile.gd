extends "res://Scripts/Arrows/ArrowProjectile.gd"

onready var basicArrowProjectile = preload("res://Scenes/Arrows/BasicArrowProjectile.tscn")

func _ready():
	mass = 30.0
	ignoreShield = false
	maxBounce = 1
	recoilScale = 2.0
	stuckDespawnTime = 3


func onLaunch(vel : Vector2, pos : Vector2, rot : float, origin):
	var arrowInst1 = basicArrowProjectile.instance()
	var arrowInst2 = basicArrowProjectile.instance()
	var arrowInst3 = basicArrowProjectile.instance()
	var arrowInst4 = basicArrowProjectile.instance()
	
	arrowInst1.applyRecoil = false
	arrowInst2.applyRecoil = false
	arrowInst3.applyRecoil = false
	arrowInst4.applyRecoil = false
	
	get_tree().get_root().add_child(arrowInst1)
	get_tree().get_root().add_child(arrowInst2)
	get_tree().get_root().add_child(arrowInst3)
	get_tree().get_root().add_child(arrowInst4)
	
	arrowInst1.launch(rotateVector(vel, deg2rad(5)), pos, rot + deg2rad(5), origin)
	arrowInst2.launch(rotateVector(vel, deg2rad(10)), pos, rot + deg2rad(10), origin)
	arrowInst3.launch(rotateVector(vel, deg2rad(-5)), pos, rot + deg2rad(-5), origin)
	arrowInst4.launch(rotateVector(vel, deg2rad(-10)), pos, rot + deg2rad(-10), origin)
	
	print("launched spread arrow")


func rotateVector(vec : Vector2, delta : float):
	return Vector2(vec.x * cos(delta) - vec.y * sin(delta), vec.x * sin(delta) + vec.y * cos(delta))

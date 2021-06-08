extends "res://Scripts/Arrows/ArrowProjectile.gd"

func _ready():
	mass = 30.0
	ignoreShield = false
	maxBounce = 2
	pass


func onLaunch(vel : Vector2, pos : Vector2, rot : float, origin):
	print("launched basic arrow")

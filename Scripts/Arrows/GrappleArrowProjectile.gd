extends "res://Scripts/Arrows/ArrowProjectile.gd"

onready var chainLinks = get_node("Chain/ChainLinks")
onready var chainTip = get_node("Chain/ChainTip")

var tip := Vector2(0, 0)		# chain tip's global position

var other = null
var enemyStuck = false

func _ready():
	mass = 30.0
	ignoreShield = true
	maxBounce = 1
	stuckDespawnTime = 7.5


func onProcess(delta):
	var tipLoc = chainTip.global_position
	
	#rad2deg((area.global_position - global_position).angle()) + 90
	chainLinks.global_rotation = parent.global_position.angle_to_point(tipLoc) - deg2rad(90)
	chainTip.global_rotation = parent.global_position.angle_to_point(tipLoc) - deg2rad(90)
	# parent.global_position.angle_to_point(tipLoc) - deg2rad(45)
	chainLinks.region_rect.size.y = (tipLoc - parent.global_position).length()


func onPhysicsProcess(delta):
	if enemyStuck && other != null:
		var chainVel =  (parent.global_position - other.global_position).normalized() * parent.chainPull * 3
		
		other.velocity += chainVel
		print(var2str(chainVel))
		
		if other.global_position.distance_squared_to(parent.global_position) < 4096:	# 64 ^ 2
			enemyStuck = false
			other = null
			queue_free()


func onLaunch(vel : Vector2, pos : Vector2, rot : float, origin):
	parent.grappleChain = self
	tip = chainTip.global_position
	
	print("launched grapple arrow")


func onStuck(body):
	if body.get_collision_layer() == 2:
		parent.hooked = true
	elif body.get_collision_layer() == 1:
		enemyStuck = true
		other = body
		print("enemy stuck")


func onDespawn():
	parent.grappleChain = null
	parent.hooked = false

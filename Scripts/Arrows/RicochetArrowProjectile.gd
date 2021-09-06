extends "res://Scripts/Arrows/ArrowProjectile.gd"

onready var ricochetRaycast = get_node("RicochetRaycast")
var maxRicochet = 3

var justBounced = false
var oldPos = Vector2(0, 0)
var oldVel = Vector2(0, 0)
var bounceVel = Vector2(0, 0)
var bounceTimer = 10	# counts frames since last bounce
var bounceDelay = 2	# reverses velocity if another bounce occurs before this amount of frames after last bounce

var colliding = false

func _ready():
	mass = 30.0
	ignoreShield = false
	maxBounce = 2
	pass


func onLaunch(vel : Vector2, pos : Vector2, rot : float, origin):
	print("launched ricochet arrow")


func onPhysicsProcess(delta):
	if justBounced:
		bounceTimer += 1
		if bounceTimer >= bounceDelay:
			justBounced = false
		if colliding:
			pass


func _on_StuckCollider_body_entered(body):
	if active:
		if body.get_collision_layer() == 2:
			colliding = true
		if !stuck && body != parent || ignoreShield:
			if maxRicochet > 0 && body.get_collision_layer() == 2 && ricochetRaycast.is_colliding():
				maxRicochet -= 1
						
				if maxRicochet == 2:
					oldPos = position
					oldVel = velocity
					
				# if still colliding x frames after bounce, perform corner bounce
						
				if bounceTimer >= bounceDelay:
					oldPos = position
					oldVel = velocity			
					velocity = velocity.bounce(ricochetRaycast.get_collision_normal()) * 0.9
					global_position = global_position + velocity.normalized() * 16
				else:
					velocity = -oldVel * 0.9
					position = oldPos
					print("corner bounce")
				
				print("bounce x" + var2str(3 - maxRicochet))
				justBounced = true
				bounceTimer = 0
			else:
				onStuck(body)
				flying = false
				stuck = true
				
				if body.get_collision_layer() == 1:
					body.velocity += velocity
				
				velocity = Vector2(0, 0)
				# arrowCollider.disabled = true
				set_deferred("arrowCollider:disabled", true)
				
				#set new parent and correct position
				var currPos = self.global_position
				var currTrans = self.global_transform
				call_deferred("reparent", body, currPos, currTrans)
				
				# print("stuck")


func _on_StuckArea_body_exited(body):
	if body.get_collision_layer() == 2:
		# print("stop colliding")
		colliding = false

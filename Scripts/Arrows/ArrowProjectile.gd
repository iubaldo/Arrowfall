extends Area2D
class_name ArrowProjectile

var mass = 30
var velocity = Vector2(0, 0)

var launched = false
var stuck = false
var destruct = false	# true when marked for despawn
var parent
var active = true
var spawnProt = true

var applyRecoil = true	# should only be true for one arrow if multishot
var recoilScale = 1

# shield interaction
var ignoreShield = false
var currBounce = 0
var maxBounce = 2	# maximum amount of times arrow can be deflected before piercing shields

onready var arrowCollider : CollisionPolygon2D = get_node("ArrowCollider")
onready var despawnLabel : Label = get_node("DespawnDebugLabel")
onready var despawnTimer : Timer = get_node("DespawnTimer") 
onready var spawnProtTimer : Timer = get_node("SpawnProtTimer")

func _ready():
	pass
	
	
func _process(delta):
	onProcess(delta)
	if currBounce >= maxBounce:
		ignoreShield = true
		
func onProcess(delta):
	pass

func _physics_process(delta):
	if active:
		#label.text = var2str(stepify(timer.time_left, 0.01))
		onPhysicsProcess(delta)
		if launched:
			handleMovement(delta)
			
		if stuck:
			if !destruct:
				# print("stuck despawn")
				destruct = true
				despawnTimer.set_wait_time(5)
				despawnTimer.start()


func handleMovement(delta):
	velocity += gravity_vec * gravity * mass * delta
	position += velocity * delta
	rotation = velocity.angle()


func onPhysicsProcess(delta):
	pass


func launch(vel : Vector2, pos : Vector2, rot : float, origin):
	if active:
		if !launched:
			launched = true
			velocity = vel
			position = pos
			rotation = rot
			parent = origin
			
			onLaunch(vel, pos, rot, origin)
			
			if applyRecoil && velocity.length_squared() > pow(500, 2):
				parent.velocity += velocity * recoilScale * Vector2(-0.5, -0.25)
	
func onLaunch(vel : Vector2, pos : Vector2, rot : float, origin):
	pass


func _on_Arrow_body_entered(body):
	# insert damage/knockback here
	pass

	
func _on_StuckCollider_body_entered(body):
	if active:
		if !stuck && body != parent || ignoreShield:
			launched = false
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


func _on_Arrow_area_entered(area):
	if "shield" in area.get_name().to_lower(): # is this fine? feels kinda hacky but it works so idk
											   # might break if a future object has the word "shield" in its name
		currBounce += 1


func reparent(newParent, currPos, currTrans):
	get_parent().remove_child(self)
	newParent.add_child(self)
	self.global_position = currPos
	self.global_transform = currTrans


func _on_VisibilityNotifier2D_screen_exited():
	call_deferred("visibilityDespawn")


func visibilityDespawn():
	if active && !destruct && !spawnProt:
		print("visibility despawn")
		destruct = true
		despawnTimer.set_wait_time(3)
		despawnTimer.start()


func _on_DespawnTimer_timeout():
	queue_free()


func _on_SpawnProtTimer_timeout():
	spawnProt = false

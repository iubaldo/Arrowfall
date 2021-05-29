extends Area2D

var mass = 30.0
var velocity = Vector2(0, 0)

var launched = false
var stuck = false
var destruct = false
var parent
var active = true
var ignoreShield = false
var currBounce = 0
var maxBounce = 2

onready var arrowCollider : CollisionPolygon2D = get_node("ArrowCollider")
onready var label : Label = get_node("Label")
onready var timer : Timer = get_node("Timer")

func _ready():
	pass
	
func _process(delta):
	if currBounce >= maxBounce:
		ignoreShield = true

func _physics_process(delta):
	if active:
		#label.text = var2str(stepify(timer.time_left, 0.01))
		
		if launched:
			velocity += gravity_vec * gravity * mass * delta
			position += velocity * delta
			rotation = velocity.angle()
			
		if velocity == Vector2(0, 0):
			if !destruct:
				destruct = true
				timer.set_wait_time(5)
				#timer.call_deferred("start")
				timer.start()


func launch(initVel : Vector2, origin):
	if active:
		if !launched:
			launched = true
			velocity = initVel
			parent = origin


func _on_Arrow_body_entered(body):
	if active:
		if !stuck && body != parent || ignoreShield:
			#print(body.name)
			launched = false
			stuck = true
			
			if body.get_collision_layer() == 1:
				body.velocity += velocity
			
			velocity = Vector2(0, 0)
			arrowCollider.disabled = true
			
			# insert damage/knockback here
			
			#set new parent and correct position
			var currPos = self.global_position
			var currTrans = self.global_transform
			call_deferred("reparent", body, currPos, currTrans)
			
func _on_Arrow_area_entered(area):
	if "shield" in area.get_name().to_lower():
		currBounce += 1

func reparent(newParent, currPos, currTrans):
	get_parent().remove_child(self)
	newParent.add_child(self)
	self.global_position = currPos
	self.global_transform = currTrans


func _on_VisibilityNotifier2D_screen_exited():
	if active:
		if !destruct:
			destruct = true
			timer.set_wait_time(3)
			timer.start()


func _on_Timer_timeout():
	queue_free()




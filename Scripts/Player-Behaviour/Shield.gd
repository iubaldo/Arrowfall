extends Node2D

onready var shieldHitbox = get_node("ShieldHitbox")
onready var perfectParryTimer = get_node("PerfectParryTimer")
onready var shieldCDTimer = get_node("ShieldCooldownTimer")

var active = true

var rotationStepAngle = 50
var targetAngle = 0
var shieldAngle = 0
var angleFrom = 0
var angleTo = 0
var center = Vector2(0, 0)
var radiusInner = 45
var radiusOuter = 50
var fillColor = Color(255.0, 255.0, 255.0)
var outlineColor = Color(0.0, 0.0, 0.0)

func _process(delta):
	if Input.is_action_just_pressed("shield"):
		perfectParryTimer.start()
		
	if Input.is_action_just_released("shield"):
		shieldCDTimer.start()
	
	if active && shieldCDTimer.is_stopped():
		shieldHitbox.disabled = false
		# targetAngle = rad2deg(get_local_mouse_position().normalized().angle()) + 90
		angleFrom = -shieldAngle + targetAngle
		angleTo = shieldAngle + targetAngle
		
		if angleFrom > 360 && angleTo > 360:
			angleFrom = wrapf(angleFrom, 0, 360)
			angleTo = wrapf(angleTo, 0, 360)
			
		# print("from: " + var2str(angleFrom) + ", to: " + var2str(angleTo))
	else:
		shieldHitbox.disabled = true
	update()
	
#func _physics_process(delta):
#	#print("shield disabled: " + var2str(shieldHitbox.disabled))
#	#print("from:" + var2str(angleFrom) + " to: " + var2str(angleTo))
#	# print(var2str(rad2deg((get_local_mouse_position() - position).angle()) + 90))
#	pass
	
func _draw():
	if active:
		drawCircleArc()

func drawCircleArc():
	var nb_points = 64
	var points_arc = PoolVector2Array()
	var fillColors = PoolColorArray([fillColor])

	for i in range(nb_points):
		var angle_point = deg2rad(angleFrom + i * (angleTo - angleFrom) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radiusOuter)
		
	for i in range(nb_points - 2, 2, -1):
		var angle_point = deg2rad(angleFrom + i * (angleTo - angleFrom) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radiusInner)
		
	var angle_point = deg2rad(angleFrom + (angleTo - angleFrom) / nb_points - 90)
	points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radiusOuter)

	draw_polygon(points_arc, fillColors)
	# for index in range(nb_points * 2 - 4):
	# 	draw_line(points_arc[index], points_arc[index + 1], outlineColor)

func _on_Shield_area_entered(area):
	var hitAngle = rad2deg((area.global_position - global_position).angle()) + 90
	var correctedFrom = targetAngle - shieldAngle - 2.5
	var correctedTo = targetAngle + shieldAngle + 2.5
	
	# print("collision angle: " + var2str(hitAngle))
	# print("from:" + var2str(correctedFrom) + " to: " + var2str(correctedTo))
	# print("hit: " + var2str(hitAngle > correctedFrom && hitAngle < correctedTo))
	# print(var2str(position.direction_to(get_local_mouse_position())))
	
	if "arrow" in area.get_name().to_lower():	
		if (hitAngle > correctedFrom && hitAngle < correctedTo && !area.ignoreShield):
			area.velocity = area.velocity.length() * (0.25 + perfectParryTimer.time_left / perfectParryTimer.wait_time) \
			 * position.direction_to(get_local_mouse_position())
			area.position = area.position + (-area.velocity.normalized() * -40)

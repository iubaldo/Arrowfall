extends Node2D

onready var arrowhead = get_node("Arrowhead")
onready var icon = get_node("Arrowhead/Icon")
onready var player = get_parent().get_node("Player")

var targetPos = Vector2.ZERO

func _process(delta):
	targetPos = player.position
	
	var canvas = get_canvas_transform()
	var top_left = -canvas.origin / canvas.get_scale()
	var size = get_viewport_rect().size / canvas.get_scale()
	
	setMarkerPos(Rect2(top_left, size))
	setMarkerRot()
	
func _draw():
	draw_line(global_position, targetPos, Color(232, 28, 212))

func setMarkerPos(bounds : Rect2):
	if targetPos == null:	
		arrowhead.global_position.x = clamp(global_position.x, bounds.position.x, bounds.end.x)
		arrowhead.global_position.y = clamp(global_position.y, bounds.position.y, bounds.end.y)
	else:
		var displacement = global_position - targetPos
		var length
		
		var tl = (bounds.position - targetPos).angle()
		var tr = (Vector2(bounds.end.x, bounds.position.y) - targetPos).angle()
		var bl = (Vector2(bounds.position.x, bounds.end.y) - targetPos).angle()
		var br = (bounds.end - targetPos).angle()
		
		if (displacement.angle() > tl && displacement.angle() < tr) || (displacement.angle() < bl && displacement.angle() > br):
			var y_length = clamp(displacement.y, bounds.position.y - targetPos.y, bounds.end.y - targetPos.y)
			var angle = displacement.angle() - PI / 2.0
			length = y_length / cos(angle) if cos(angle) != 0 else y_length
		else:
			var x_length = clamp(displacement.x, bounds.position.x - targetPos.x, bounds.end.x - targetPos.x)
			var angle = displacement.angle()
			length = x_length / cos(angle) if cos(angle) != 0 else x_length
			
		arrowhead.global_position = polar2cartesian(length, displacement.angle()) + targetPos
	
	if bounds.has_point(global_position):
		hide()
	else:
		show()

func setMarkerRot():
	var angle = (global_position - arrowhead.global_position).angle()
	arrowhead.global_rotation = angle
	icon.global_rotation = 0
	

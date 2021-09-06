extends Node

onready var bow : Area2D = get_parent().get_node("Bow")

var stocks = 3
var knockback = 0.0
var inventory = []

var arrows = [Globals.arrowType.BASIC, Globals.arrowType.SPREAD, Globals.arrowType.LINKED, Globals.arrowType.GRAPPLE, Globals.arrowType.RICOCHET]
var currArrow = arrows[0]

func _ready():
	currArrow = arrows[0]

func _process(delta):
	# debug arrow selection, remove later
	if Input.is_action_just_pressed("debug_next_item"):
		if arrows.find(currArrow) + 1 > arrows.size() - 1:
			currArrow = arrows[0]
		else:
			currArrow = arrows[arrows.find(currArrow) + 1]
		
		match(currArrow):
			Globals.arrowType.BASIC:
				bow.setArrowType("basic")
			Globals.arrowType.SPREAD:
				bow.setArrowType("spread")
			Globals.arrowType.LINKED:
				bow.setArrowType("linked")
			Globals.arrowType.GRAPPLE:
				bow.setArrowType("grapple")
			Globals.arrowType.RICOCHET:
				bow.setArrowType("ricochet")
			null:
				bow.setArrowType("basic")
			_:
				bow.setArrowType("basic")
				
	if Input.is_action_just_pressed("debug_prev_item"):
		if arrows.find(currArrow) - 1 < 0:
			currArrow = arrows[arrows.size() - 1]
		else:
			currArrow = arrows[arrows.find(currArrow) - 1]
		
		match(currArrow):
			Globals.arrowType.BASIC:
				bow.setArrowType("basic")
			Globals.arrowType.SPREAD:
				bow.setArrowType("spread")
			Globals.arrowType.LINKED:
				bow.setArrowType("linked")
			Globals.arrowType.GRAPPLE:
				bow.setArrowType("grapple")
			Globals.arrowType.RICOCHET:
				bow.setArrowType("ricochet")
			null:
				bow.setArrowType("basic")
			_:
				bow.setArrowType("basic")


func addItem(item):
	if !inventory.empty:
		inventory.pop_front()
			
	inventory.push_back(item)


func dropItem(type):
	inventory.pop_front()

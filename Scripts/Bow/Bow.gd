extends Node2D

# onready var tileMap : TileMap = get_parent().get_parent().get_node("ForegroundTileMap")
onready var bowSprite : Sprite = get_node("BowSprite")

# arrow textures
onready var basicArrow : Texture = load("res://Sprites/bow and arrow cut/tile005.png")
onready var spreadArrow : Texture = load("res://Sprites/bow and arrow cut/tile005.png") # change later to diff texture
onready var linkedArrow : Texture = load("res://Sprites/bow and arrow cut/tile005.png")

# arrow scenes
const BASIC_ARROW = preload("res://Scenes/Arrows/BasicArrowProjectile.tscn")
const SPREAD_ARROW = preload("res://Scenes/Arrows/SpreadArrowProjectile.tscn")
const LINKED_ARROW = preload("res://Scenes/Arrows/LinkedArrowProjectile.tscn")

var mousePos
var shootPower = 0
var phase = 0

var currArrow = Globals.arrowType.BASIC
var currArrowProjectile = BASIC_ARROW

func _process(delta):
	if !get_parent().usingController:
		mousePos = get_local_mouse_position()
		rotation += mousePos.angle()
	else:
		rotation = get_parent().shootVector.normalized().angle()
	
	
	#update bowSprite by power
	if shootPower < 200:
		phase = 0
		$BowSprite.set_frame(0)
	elif shootPower >= 200 && shootPower < 500:
		phase = 1
		$BowSprite.set_frame(3)
	elif shootPower >= 500 && shootPower < 1000:
		phase = 2
		$BowSprite.set_frame(1)
	elif shootPower >= 1000:
		phase = 3
		$BowSprite.set_frame(4)
		
	
	if phase != 0:
		$ArrowSprite.visible = true
		
		# set arrow sprite position based on draw phase
		match phase:
			1:
				$ArrowSprite.position =  $DrawArrowPos1.position + Vector2(0, 0.6)
			2:
				$ArrowSprite.position =  $DrawArrowPos2.position + Vector2(0, 0.6)
			3:
				$ArrowSprite.position =  $DrawArrowPos3.position + Vector2(0, 0.6)
		
		# set arrow sprite based on arrowType
		match currArrow:
			Globals.arrowType.BASIC:
				$ArrowSprite.texture = basicArrow
				currArrowProjectile = BASIC_ARROW
			Globals.arrowType.SPREAD:
				$ArrowSprite.texture = spreadArrow
				currArrowProjectile = SPREAD_ARROW
			Globals.arrowType.LINKED:
				$ArrowSprite.texture = linkedArrow
				currArrowProjectile = LINKED_ARROW
			_:
				$ArrowSprite.texture = basicArrow
				currArrowProjectile = BASIC_ARROW
				
	else:
		$ArrowSprite.visible = false


func setShootPower(power : float):
	shootPower = power
	
	
func setArrowType(type : String):
	match type.to_lower():
		"basic":
			currArrow = Globals.arrowType.BASIC
		"spread":
			currArrow = Globals.arrowType.SPREAD
		"linked":
			currArrow = Globals.arrowType.LINKED
		_:
			currArrow = Globals.arrowType.BASIC

	print("set arrow type to " + type)
	

func _on_Bow_body_entered(body):
	# if body == member of "platform":
	#	get_parent().disableShoot()
	
	pass # Replace with function body.

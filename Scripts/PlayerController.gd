extends KinematicBody2D

onready var playerSprite : Sprite = get_node("PlayerSprite")
onready var powerLabel : Label = get_node("ShootPowerLabel")
onready var arrowCDTimer : Timer = get_node("Timers/ArrowCDTimer")
onready var wallSlideCDTimer = get_node("Timers/WallSlideCDTimer")
onready var wallStickTimer = get_node("Timers/WallStickTimer")
onready var jumpForgivenessTimer = get_node("Timers/JumpForgivenessTimer")
onready var coyoteTimer = get_node("Timers/CoyoteTimer")
onready var rWallcasts = get_node("Wallcasts/RightWallcasts")
onready var lWallcasts = get_node("Wallcasts/LeftWallcasts")
onready var bow : Area2D = get_node("Bow")
onready var shield : Node2D = get_node("Shield")
# onready var offScreenMarker = get_parent().get_node("OffScreenMarker")
const ARROW = preload("res://Scenes/Arrow.tscn")

const ACCELERATION = 800
const MAX_SPEED = 200
const JUMPFORCE = -600
const MAX_JUMPFORCE = -600
const MIN_JUMPFORCE = -300
const GRAVITY = 1700
const FRICTION = 0.25
const AIR_FRICTION = 0.02

var velocity = Vector2()
var mousePos = Vector2()
var isJumping = false
var doubleJump = true
const WALL_JUMP_VELOCITY = Vector2(225, -550)
var wallDirection = 1

var canShoot = true
var shootPower = 0
var maxPower = 1000
var arrowType = "basic"
var aimVector = Vector2()
var shootVector = Vector2()

var pressFire = false
var releaseFire = false
var pressShield = false
var pressJump = false

var shieldActive = false
var maxShieldPower = 30
var shieldPower = 30
var minShieldPower = 5
var shieldDecayRate = 12.5
var shieldRegenRate = 5

export var playerID := 0
export var usingController = false
var deadzone0 = 0.3

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)
	# set_position(Vector2(500, 300))
	$AnimationTree.active = true
	
func setControls(ID: int, controller: bool):
	playerID = ID
	usingController = controller
	
func _process(delta):
	if shootPower != 0:
		powerLabel.text = var2str(int(shootPower))
	else:
		powerLabel.text = ""
		
	if !usingController:
		mousePos = get_local_mouse_position()
		shootVector = mousePos.normalized()
	else:
		aimVector = Vector2(Input.get_joy_axis(playerID, JOY_AXIS_2), Input.get_joy_axis(playerID, JOY_AXIS_3))
		if aimVector.length() >= deadzone0:
			shootVector = aimVector
	
	if !usingController:
		pressFire = true if Input.is_action_pressed("keyboard_fire") else false
		releaseFire = true if Input.is_action_just_released("keyboard_fire") else false
		pressShield = true if Input.is_action_pressed("keyboard_shield") else false
		pressJump = true if Input.is_action_just_pressed("keyboard_jump") else false
	else:
		pressFire = true if Input.is_action_pressed("controller_fire_" + var2str(playerID)) else false
		releaseFire = true if Input.is_action_just_released("controller_fire_" + var2str(playerID)) else false
		pressShield = true if Input.is_action_pressed("controller_shield_" + var2str(playerID)) else false
		pressJump = true if Input.is_action_just_pressed("controller_jump_" + var2str(playerID)) else false
	
	if pressFire:
		if shootPower < maxPower:
			shootPower += 500 * delta
			
			if shootPower > 1000:
				shootPower = 1000
		
	if releaseFire:
		if shootPower >= 200:
			var arrowInst = ARROW.instance()
			get_parent().add_child(arrowInst)
			arrowInst.position = get_node("Bow").get_node("ArrowSpawnPosition").global_position
			arrowInst.rotation = shootVector.angle()
			arrowInst.launch(shootVector * shootPower, self)
			
		# recoil
		if shootPower >= 500:
			velocity += shootVector * shootPower * Vector2(-0.5, -0.25)
			
		shootPower = 0	
		
	bow.setShootPower(shootPower)
	bow.setArrowType(arrowType)
	
	
	if pressShield && shield.shieldCDTimer.is_stopped():
		shieldPower = clamp(shieldPower - shieldDecayRate * delta, minShieldPower, maxShieldPower)	
		shieldActive = true
		shield.active = true		
		shield.shieldAngle = shieldPower
		shield.targetAngle = rad2deg(shootVector.angle()) + 90
	else:
		shieldPower = clamp(shieldPower + shieldRegenRate * delta, minShieldPower, maxShieldPower)
		
		shield.active = false
		shieldActive = false

	
# Called 60 times per second
func _physics_process(delta):	
	# animation handling
	if velocity.y < 0:
		$AnimationTree.set("parameters/InAir/current", 1)
	else:
		$AnimationTree.set("parameters/InAir/current", 0)
		
	
	$AnimationTree.set("parameters/MoveTime/scale", 1 + int(abs(velocity.x) * 0.001))
	$AnimationTree.set("parameters/InAirState/current", int(!is_on_floor())) #$GroundDetectRaycast.is_colliding())
	
	# reset double jump
	if is_on_floor():
		# doubleJump = true
		$AnimationTree.set("parameters/Movement/current", int(abs(velocity.x) > 50))


	# sprite direction
	if wallDirection == 0:
		if !usingController:
			if mousePos.x >= 0:
				playerSprite.flip_h = false
			else:
				playerSprite.flip_h = true
		else:
			if shootVector.x >= 0:
				playerSprite.flip_h = false
			else:
				playerSprite.flip_h = true
	elif wallDirection != 0 && handleMoveInput().normalized().x == wallDirection:
		playerSprite.flip_h = wallDirection > 0
		
func getHWeight():
	if is_on_floor():
		return 0.2
	else:
		if handleMoveInput().normalized().x == 0:
			return 0.02
		elif handleMoveInput().normalized().x == sign(velocity.x) && abs(velocity.x) > ACCELERATION:
			return 0.0
		else: 
			return 0.1
			
func handleWallStick():
	if handleMoveInput().normalized().x != 0 && handleMoveInput().normalized().x != wallDirection:
		if wallStickTimer.is_stopped():
			wallStickTimer.start()
	else:
		wallStickTimer.stop()
		
func handleMoveInput():
	var moveVector = Vector2.ZERO
	if !usingController:
		var inputVector = Vector2(Input.get_action_strength("keyboard_move_right") - Input.get_action_strength("keyboard_move_left") , \
			Input.get_action_strength("keyboard_move_up") - Input.get_action_strength("keyboard_move_down"))
		moveVector = inputVector.normalized()
	else:
		var inputVector = Vector2(Input.get_joy_axis(playerID, JOY_AXIS_0), Input.get_joy_axis(playerID, JOY_AXIS_1))
		if inputVector.length() >= deadzone0:
			moveVector = inputVector.normalized()
	return moveVector

func applyMovement(inputVector, delta):
	var wasOnFloor = is_on_floor()
	
	if inputVector != Vector2.ZERO:
		velocity.x += inputVector.x * ACCELERATION * delta;
		velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	else:
		if is_on_floor():
			velocity.x = lerp(velocity.x, 0, FRICTION)
		elif wallDirection == 0:
			velocity.x = lerp(velocity.x, 0, AIR_FRICTION)
			
	velocity = move_and_slide(velocity, Vector2.UP)
		
func jump():
	velocity.y = MAX_JUMPFORCE
	isJumping = true
	
func wallJump():
	var wallJumpVelocity = WALL_JUMP_VELOCITY
	wallJumpVelocity.x *= -wallDirection
	velocity = wallJumpVelocity
	isJumping = true
	
func applyGravity(delta):
	velocity.y += GRAVITY * delta
	if isJumping && velocity.y >= 0:
		isJumping = false

func capGravityWallSlide():
	var maxVelocity = 128 if !Input.is_action_pressed("ui_down") else 2 * 128
	velocity.y = min(velocity.y, maxVelocity)
	
func isValidWall(wallcasts):
	for raycast in wallcasts.get_children():
		if raycast.is_colliding():
			var dot = acos(Vector2.UP.dot(raycast.get_collision_normal()))
			if dot > PI * 0.35 && dot < PI * 0.55: # a little more than 60 degrees
				return true
	return false
			
func getWallDirection():
	var wallLeft = isValidWall(lWallcasts)
	var wallRight = isValidWall(rWallcasts)
	
	if wallLeft && wallRight:
		wallDirection = handleMoveInput().normalized().x
	elif -int(wallLeft) + int(wallRight) == handleMoveInput().normalized().x: # can only wall slide when input is in same direction as wall
		wallDirection = -int(wallLeft) + int(wallRight)
	else:
		wallDirection = 0

#func _on_BlastZone_body_exited(body):
#	if body == self:
#		#replace with actual respawn later
#		get_tree().reload_current_scene()
#		# pass

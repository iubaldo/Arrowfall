extends KinematicBody2D

onready var player = get_node("Player")
onready var playerSprite : Sprite = get_node("PlayerSprite")
onready var playerHitbox = get_node("PlayerHitbox")
onready var playerFSM = get_node("PlayerFSM")
onready var powerLabel : Label = get_node("ShootPowerLabel")
onready var arrowCDTimer : Timer = get_node("Timers/ArrowCDTimer")
onready var wallSlideCDTimer = get_node("Timers/WallSlideCDTimer")
onready var wallStickTimer = get_node("Timers/WallStickTimer")
onready var jumpForgivenessTimer = get_node("Timers/JumpForgivenessTimer")
onready var respawnStasisTimer = get_node("Timers/RespawnStasisTimer")
onready var coyoteTimer = get_node("Timers/CoyoteTimer")
onready var rWallcasts = get_node("Wallcasts/RightWallcasts")
onready var lWallcasts = get_node("Wallcasts/LeftWallcasts")
onready var groundcasts = get_node("Groundcasts")
onready var bow : Area2D = get_node("Bow")
onready var shield : Node2D = get_node("Shield")
onready var animTree = get_node("AnimationTree")

var blueSprite
var redSprite
var greenSprite
var orangeSprite

# onready var offScreenMarker = get_parent().get_node("OffScreenMarker")
const ARROW = preload("res://Scenes/Arrow.tscn")

const ACCELERATION = 800
const MAX_SPEED = 6 * Globals.UNIT_SIZE
const JUMPFORCE = -600
const MAX_JUMPFORCE = -600
const MIN_JUMPFORCE = -300
const MAX_JUMP_HEIGHT = 3.25 * Globals.UNIT_SIZE
const MIN_JUMP_HEIGHT = 1 * Globals.UNIT_SIZE
const JUMP_DURATION = 0.5 # time to reach peak of jump
const GRAVITY = 2 * MAX_JUMP_HEIGHT / pow(JUMP_DURATION, 2) #orignal value: 1700
const MAX_JUMP_VELOCITY = -sqrt(2 * GRAVITY * MAX_JUMP_HEIGHT)
const MIN_JUMP_VELOCITY = -sqrt(2 * GRAVITY * MIN_JUMP_HEIGHT)
const FRICTION = 0.25
const AIR_FRICTION = 0.02
const WALL_JUMP_VELOCITY = Vector2(225, -550)
const DROP_THRU_BIT = 6 # 7th collision layer


var velocity = Vector2()
var mousePos = Vector2()
var isJumping = false
var doubleJump = true
var wallDirection = 1
var useGravity = true
var stasis = false
var invincible = false
var snapVector = Vector2.DOWN * 32
var isGrounded = false

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
var shieldPower = 0
var minShieldPower = 5
var shieldDecayRate = 12.5
var shieldRegenRate = 5

var color = "blue"
var charClass = ""
var number = -1

export var playerID := 0
export var usingController = false
var deadzone0 = 0.3

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)
	$AnimationTree.active = true
	
	#gravity = 2 * MAX_JUMP_HEIGHT / pow(jump_durato)
	
	
func setControls(ID: int, controller: bool):
	playerID = ID
	usingController = controller
	
	
func _process(delta):
	if !respawnStasisTimer.is_stopped():
		useGravity = false
		invincible = true
	else:
		useGravity = true
		invincible = false
	
	playerHitbox.disabled = true if invincible else false
	
	if isGrounded:
		snapVector = Vector2.DOWN * 32		
	if pressJump:
			snapVector = Vector2.ZERO
	
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
	checkIsGrounded()
	
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
		
		
func _input(event):
	if event is InputEventKey && (stasis || invincible):
		stasis = false
		invincible = false
		
		
func onRespawn():
	player.stocks -= 1
	invincible = true
	stasis = true
	velocity = Vector2.ZERO
	respawnStasisTimer.start()
	
		
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
	if !stasis:
		var wasOnFloor = is_on_floor()
		
		if inputVector != Vector2.ZERO:			
			velocity.x += inputVector.x * ACCELERATION * delta;
			velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
			
			if ((!usingController && inputVector.y < 0) || usingController && inputVector.y > 0.4) && \
				![playerFSM.states.jump, playerFSM.states.fall].has(playerFSM.state):
				if (!usingController && inputVector.x != 0) || (usingController && abs(inputVector.x) > 0.2):
					velocity.x *= 0.9
				else:
					velocity.x = 0
		else:
			if is_on_floor():
				velocity.x = lerp(velocity.x, 0, FRICTION)
			elif wallDirection == 0:
				velocity.x = lerp(velocity.x, 0, AIR_FRICTION)

		velocity.y = move_and_slide_with_snap(velocity, snapVector, Vector2.UP, true, 4, deg2rad(60)).y
		
		# if !pressJump && velocity.y < -500:
		# 	velocity.y = -500
		
		
func jump():
	velocity.y = MAX_JUMPFORCE
	isJumping = true
	
func wallJump():
	var wallJumpVelocity = WALL_JUMP_VELOCITY
	wallJumpVelocity.x *= -wallDirection
	velocity = wallJumpVelocity
	isJumping = true
	
	
func applyGravity(delta):
	if useGravity && !stasis && !isGrounded:
		velocity.y += GRAVITY * delta
		if isJumping && velocity.y >= 0:
			isJumping = false


func capGravityWallSlide():
	var maxVelocity = 128 if !Input.is_action_pressed("ui_down") else 2 * 128
	velocity.y = min(velocity.y, maxVelocity)
	
	
func checkIsGrounded():
	for groundcast in groundcasts.get_children():
		if groundcast.is_colliding():
			return true
	return false
	
	
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


func _on_RespawnStasisTimer_timeout():
	stasis = false
	invincible = false
	

func _on_PlatformDetector_body_exited(body):
	set_collision_mask_bit(DROP_THRU_BIT, true)


func change_class(newCharClass):
	charClass = newCharClass
	match newCharClass:
		"hood":
			blueSprite = load("res://Sprites/hooded figure cut/blueHoodTileset.png")
			redSprite = load("res://Sprites/hooded figure cut/redHoodTileset.png")
			greenSprite = load("res://Sprites/hooded figure cut/greenHoodTileset.png")
			orangeSprite = load("res://Sprites/hooded figure cut/orangeHoodTileset.png")

func change_color(newColor):
	color = newColor
	match newColor:
		"blue":
			get_node("PlayerSprite").set_texture(blueSprite)
		"red":
			get_node("PlayerSprite").set_texture(redSprite)
		"green":
			get_node("PlayerSprite").set_texture(greenSprite)
		"orange":
			get_node("PlayerSprite").set_texture(orangeSprite)

extends KinematicBody2D

# preloads
onready var player = get_node("Player") # player.gd
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
onready var respawnPlatform = get_node("RespawnPlatform")

# sprites
var blueSprite
var redSprite
var greenSprite
var orangeSprite

# onready var offScreenMarker = get_parent().get_node("OffScreenMarker")

# movement variables
var velocity = Vector2()
const ACCELERATION = 25 * 32
const MAX_SPEED = 6 * 32
const MAX_JUMP_HEIGHT = 3 * 32
const MIN_JUMP_HEIGHT = 1 * 32
const JUMP_DURATION = 0.3 # time to reach peak of jump
const GRAVITY = 2 * MAX_JUMP_HEIGHT / pow(JUMP_DURATION, 2) # orignal value: 1700
const MAX_JUMP_VELOCITY = -sqrt(2 * GRAVITY * MAX_JUMP_HEIGHT)
const MIN_JUMP_VELOCITY = -sqrt(2 * GRAVITY * MIN_JUMP_HEIGHT)
const FRICTION = 0.25
const AIR_FRICTION = 0.02
const WALL_JUMP_VELOCITY = Vector2(250, -600)
const DROP_THRU_BIT = 6 # 7th collision layer
var snapVector = Vector2.DOWN * 32 # used to correct movement on slopes
var dirInfluence = 1.0 # scales player's input influence during hitstun/free fall

# state variables
var isJumping = false 
var doubleJump = true
var wallDirection = 1
var useGravity = true
var stasis = false
var isGrounded = false

var grappleChain = null
var hooked = false
var chainVelocity := Vector2(0, 0)
var chainPull = 32

# shooting variables
var mousePos = Vector2()
var canShoot = true
var chargeRate = 500
var shootPower = 0
var maxPower = 1000
var aimVector = Vector2()
var shootVector = Vector2()

# button press variables
var pressFire = false
var releaseFire = false
var pressShield = false
var pressJump = false
var releasedJump = false

# shielding variables
var shieldActive = false
var maxShieldPower = 30
var shieldPower = 0
var minShieldPower = 5
var shieldDecayRate = 12.5
var shieldRegenRate = 5

# character variables
var color = "blue"
var charClass = ""
var number = -1

# controller variables
export var playerID := 0
export var usingController = false
var deadzone0 = 0.3

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)
	$AnimationTree.active = true
	
	
func setControls(ID: int, controller: bool):
	playerID = ID
	usingController = controller
	
	
func _process(delta):
	#if usingController:
	#	print(var2str(shootVector))
	
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
		releasedJump = true if Input.is_action_just_released("keyboard_jump") else false
	else:
		pressFire = true if Input.is_action_pressed("controller_fire_" + var2str(playerID)) else false
		releaseFire = true if Input.is_action_just_released("controller_fire_" + var2str(playerID)) else false
		pressShield = true if Input.is_action_pressed("controller_shield_" + var2str(playerID)) else false
		pressJump = true if Input.is_action_just_pressed("controller_jump_" + var2str(playerID)) else false
		releasedJump = true if Input.is_action_just_released("controller_jump_" + var2str(playerID)) else false
	
	if pressFire:
		if shootPower < maxPower:
			shootPower += chargeRate * delta
			
			if shootPower > 1000:
				shootPower = 1000
		
	if releaseFire:
		if shootPower >= 200:
			var arrowInst = bow.currArrowProjectile.instance()
			get_tree().get_root().add_child(arrowInst)
			var vel = shootVector * shootPower
			var pos = bow.get_node("ArrowSpawnPosition").global_position
			var rot = shootVector.angle()
			arrowInst.launch(vel, pos, rot, self)
		shootPower = 0	
			
	bow.setShootPower(shootPower)
	
	
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
func _physics_process(_delta):
	checkIsGrounded()
	
	# grapple arrow movement calculations
	if hooked && grappleChain != null && is_instance_valid(grappleChain):
		chainVelocity = (grappleChain.global_position - global_position).normalized() * chainPull
		
		if chainVelocity.y > 0:
			chainVelocity.y *= 0.55	# pulling downwards is weaker
		else:
			chainVelocity.y *- 1.65	# pulling upwards is stronger
			
		if sign(chainVelocity.x) != sign(velocity.x):
			chainVelocity.x *= 0.7	# if we are trying to move in a different direction than the chain, reduce its pull
		
		print(var2str(chainVelocity))
	else:
		chainVelocity = Vector2(0, 0)
	
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
	
	# if the player takes any action before respawn stasis expires
	if (stasis && (event is InputEventKey || event is InputEventMouseButton || event is InputEventJoypadButton)):
		_on_RespawnStasisTimer_timeout()
	
	# if pressJump && velocity.y < MIN_JUMP_VELOCITY:
	# 	velocity.y = MIN_JUMP_VELOCITY


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
		velocity += chainVelocity


func jump():
	velocity.y = MAX_JUMP_VELOCITY
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


func onRespawn():
	print("onRespawn")
	respawnStasisTimer.start()
	player.stocks -= 1
	stasis = true
	useGravity = false
	playerHitbox.disabled = false
	velocity = Vector2.ZERO
	respawnPlatform.visible = true
	
	# for i in range (0, 10):
	# 	velocity.y = 0.1
		

func _on_RespawnStasisTimer_timeout():
	stasis = false
	useGravity = true
	playerHitbox.disabled = true
	respawnPlatform.visible = false
	

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

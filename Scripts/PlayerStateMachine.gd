extends "res://Scripts/StateMachine.gd"

onready var stateLabel : Label = parent.get_node("StateLabel")
var canDoubleJump = true

func _ready():
	addState("idle")
	addState("run")
	addState("jump")
	addState("fall")
	addState("wallSlide")
	
	call_deferred("setState", states.idle)
	
func _process(delta):	
	if parent.pressJump:
		parent.jumpForgivenessTimer.start()
		if state == states.wallSlide:
			parent.wallJump()
			canDoubleJump = true
			setState(states.jump)
		elif [states.idle, states.run].has(state) || !parent.coyoteTimer.is_stopped():
			# parent.velocity.y = parent.JUMPFORCE
			parent.coyoteTimer.stop()
			parent.jump()
		elif [states.jump, states.fall].has(state) && canDoubleJump:
			# parent.velocity.y = parent.JUMPFORCE
			parent.jump()
			canDoubleJump = false	
			setState(states.jump)
			
	# jump forgiveness
	if ([states.idle, states.run].has(state) || !parent.coyoteTimer.is_stopped()) && !parent.jumpForgivenessTimer.is_stopped():
		parent.coyoteTimer.stop()
		parent.jumpForgivenessTimer.stop()
		parent.jump()
		
	#	if [states.jump, states.doubleJump].has(state):
		# variable jump height here
	#		pass

# virtual
func stateLogic(delta): 
	parent.getWallDirection()
	
	var input = Vector2.ZERO
	if state != states.wallSlide:
		input = parent.handleMoveInput()
		
	parent.applyMovement(input, delta)
	parent.applyGravity(delta)
	
	if state == states.wallSlide:
		parent.capGravityWallSlide()
		parent.handleWallStick()

# virtual
func getTransition(delta): 
	match state:
		states.idle:
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif abs(parent.velocity.x) >= 16:
				return states.run
		states.run:
			if !parent.is_on_floor():
				if parent.velocity.y < 0:
					return states.jump
				elif parent.velocity.y > 0:
					return states.fall
			elif abs(parent.velocity.x) < 16:
				return states.idle
		states.jump:
			if parent.wallDirection != 0 && parent.wallSlideCDTimer.is_stopped():
				return states.wallSlide
			elif parent.is_on_floor():
				return states.idle
			elif parent.velocity.y >= 0:
				return states.fall
		states.fall:
			if parent.wallDirection != 0 && parent.wallSlideCDTimer.is_stopped():
				return states.wallSlide
			elif parent.is_on_floor():
				return states.idle
			elif parent.velocity.y < 0:
				return states.jump
		states.wallSlide:
			if parent.is_on_floor():
				return states.idle
			elif parent.wallDirection == 0:
				return states.fall
	return null
	
	
# virtual
func enterState(newState, oldState):
	match newState:
		states.idle:
			canDoubleJump = true
			pass
		states.run:
			canDoubleJump = true
			pass
		states.jump:
			pass
		states.fall:
			parent.coyoteTimer.start()
		states.wallSlide:
			pass

# virtual
func exitState(oldState, newState):
	match oldState:
		states.wallSlide:
			#canDoubleJump = true
			parent.wallSlideCDTimer.start()

func _on_WallStickTimer_timeout():
	if state == states.wallSlide:
		setState(states.fall)
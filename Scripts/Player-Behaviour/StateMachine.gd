extends Node
class_name StateMachine

var states = {}
var state = null setget setState
var prevState = null

onready var parent = get_parent()


func _physics_process(delta):
	if state != null:
		stateLogic(delta)
		var transition = getTransition(delta)
		if transition != null:
			setState(transition)


# virtual
func stateLogic(delta): 
	pass

# virtual
func getTransition(delta): 
	return null
	
# virtual
func enterState(newState, oldState):
	pass

# virtual
func exitState(oldState, newState):
	pass
	
func setState(newState):
	prevState = state
	state = newState
	
	if prevState != null:
		exitState(prevState, newState)
	if newState != null:
		enterState(newState, prevState)
		
func addState(stateName : String):
	states[stateName] = states.size()

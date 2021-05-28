extends Node

var currScreen = ""
var lobby = preload("res://Scenes/Lobby.tscn")
var battle = preload("res://Scenes/Main Scene.tscn")
var mainMenu = preload("res://Scenes/Main Menu.tscn")


# Sets original scene to ready select scren
func _ready():
	Input.connect("joy_connection_changed",self,"_joy_connection_changed")
	change_screen("Main Menu")
	for controller in Input.get_connected_joypads():
		if (Input.get_joy_guid(controller) != "__XINPUT_DEVICE__"):
			print(Input.get_joy_guid(controller))
			ControllerHandler.add_player(controller)	

func _process(delta):
	pass	

		
			
func _joy_connection_changed(id, connected):
	if (connected):
		if (Input.get_joy_guid(id) != "__XINPUT_DEVICE__"):
			print("Adding device id " + str(id))		
			ControllerHandler.add_player(id)
	if (!connected):
		print("Removing device id " + str(id))
		ControllerHandler.remove_player(id)
		
		
		
#Types of Screens: "Battle, Lobby, Main Menu"		
func change_screen(newScreenType):
	var next_screen
	match newScreenType:
		"Main Menu":
			next_screen = mainMenu.instance()
		"Lobby":
			next_screen = lobby.instance()
		"Battle":
			next_screen = battle.instance()
	match currScreen:
		"":
			pass
		"Main Menu":
			get_node("Main Menu").queue_free()
		"Lobby":
			get_node("Lobby").queue_free()
			if newScreenType == "Battle":
				pass
		"Battle":
			get_node("Main Scene").queue_free()

	currScreen = newScreenType
	add_child(next_screen)
	
	

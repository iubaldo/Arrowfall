extends Node

var currScene = "Lobby"
var lobby = preload("res://Scenes/Lobby.tscn")
var battle = preload("res://Scenes/Main Scene.tscn")




# Sets original scene to ready select scren
func _ready():
	Input.connect("joy_connection_changed",self,"_joy_connection_changed")
	add_child(lobby.instance())
	for controller in Input.get_connected_joypads():
		if (Input.get_joy_guid(controller) != "__XINPUT_DEVICE__"):
			print(Input.get_joy_guid(controller))
			get_node("Lobby").get_node("LobbyHandler").add_player(controller)	

func _process(delta):
	if currScene == "Lobby":
		if Input.is_action_pressed("debug_startGame"):
			currScene = "Battle"
	
			get_node("Lobby").queue_free()
			var batInstance = battle.instance()
			add_child(batInstance)
			var battleScript = batInstance.get_node("PlayerManager")
		
			
func _joy_connection_changed(id, connected):
	if (connected):
		if (Input.get_joy_guid(id) != "__XINPUT_DEVICE__"):
			print("Adding device id " + str(id))		
			get_child(0).get_node("LobbyHandler").add_player(id)
	if (!connected):
		print("Removing device id " + str(id))
		get_child(0).get_node("LobbyHandler").remove_player(id)
			

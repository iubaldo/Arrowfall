extends Node
const PLAYER = preload("res://Scenes/Player.tscn")


var controllerPlayers = [null, null, null, null, null, null, null, null]

var num_players = 0

var keyboardPlayer

func _ready():
	keyboardPlayer = PLAYER.instance()
	keyboardPlayer.setControls(-1, false)


func add_player(id: int):
	# if (!usingController && !keyboardAvailable) ||
	if ( id >= 7 ):
		return
	num_players += 1
	var player = PLAYER.instance()
	controllerPlayers[id] = player
	player.setControls(id, true)

func remove_player(id: int):
	
	var player = controllerPlayers[id]
	if (Main.currScreen == "Lobby"):
		var LobbyNode = get_tree().get_root().get_node("Lobby")
		for character in LobbyNode.allCharacters:
			if player == character:
				LobbyNode.remove_character(player)
	player.queue_free()
	controllerPlayers[id] = null
	num_players -= 1 
	

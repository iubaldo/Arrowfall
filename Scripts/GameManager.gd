extends Node

const PLAYER = preload("res://Scenes/Player.tscn")

onready var playerSpawnPoint1 = get_node("PlayerSpawnPoint1")
onready var playerSpawnPoint2 = get_node("PlayerSpawnPoint2")

var numPlayers = 0

func _process(delta):
	if Input.is_action_just_pressed("debug_createPlayerController"):
		spawnPlayer(true)
	elif Input.is_action_just_pressed("debug_createPlayerKeyboard"):
		spawnPlayer(false)
		
func spawnPlayer(usingController: bool):
	if usingController:
		var player = PLAYER.instance()
		add_child(player)
		player.global_position = playerSpawnPoint2.global_position
		player.setControls(numPlayers, true)
		player.name = "Player2"
		numPlayers += 1
	else:
		var player = PLAYER.instance()
		add_child(player)
		player.global_position = playerSpawnPoint1.global_position
		player.setControls(numPlayers, false)
		player.name = "Player1"
		numPlayers += 0
	
	print("player " + var2str(numPlayers) + " spawned")

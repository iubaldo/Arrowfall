extends Node2D

const PLAYER = preload("res://Scenes/Player.tscn")

onready var playerSpawnPoint1 = get_parent().get_node("PlayerSpawnPoint1")
onready var playerSpawnPoint2 = get_parent().get_node("PlayerSpawnPoint2")

var players = []
var numPlayers = 0

func _process(delta):
	for player in players:
		if player.get_node("Player").stocks <= 0:
			players.remove(players.find(player, 0))
			if players.size() <= 1:
				print("Game!")
	
	if Input.is_action_just_pressed("debug_createPlayerController"):
		spawnPlayer(true)
	elif Input.is_action_just_pressed("debug_createPlayerKeyboard"):
		spawnPlayer(false)
		
		

func spawnPlayer(usingController: bool):
	var player = PLAYER.instance()
	get_parent().add_child(player)
	players.push_back(player)
	
	if usingController:
		player.global_position = playerSpawnPoint2.global_position
		player.setControls(numPlayers, true)
		player.name = "Player2"
		numPlayers += 1
	else:
		
		player.global_position = playerSpawnPoint1.global_position
		player.setControls(numPlayers, false)
		player.name = "Player1"
		numPlayers += 0
	
	print("player " + var2str(numPlayers) + " spawned")

func _on_BlastZone_body_exited(body):
	for player in players:
		if player == body:
			player.global_position = Vector2(448, 126)
			player.onRespawn()
			print(player.name + " stocks remaining: " + var2str(player.get_node("Player").stocks))			

extends Node

const PLAYER = preload("res://Scenes/Player.tscn")

const blueHoodSprite = preload("res://Sprites/hooded figure cut/blueHoodTileset.png")
const redHoodSprite = preload("res://Sprites/hooded figure cut/redHoodTileset.png")
const greenHoodSprite = preload("res://Sprites/hooded figure cut/greenHoodTileset.png")
const orangeHoodSprite = preload("res://Sprites/hooded figure cut/orangeHoodTileset.png")


onready var SpawnPoint1 = get_parent().get_node("./PlayerSpawnPoints/Spawn Point 1")
onready var SpawnPoint2 = get_parent().get_node("./PlayerSpawnPoints/Spawn Point 2")
onready var SpawnPoint3 = get_parent().get_node("./PlayerSpawnPoints/Spawn Point 3")
onready var SpawnPoint4 = get_parent().get_node("./PlayerSpawnPoints/Spawn Point 4")

onready var P1Box = get_parent().get_node("./CanvasLayer/Ready-Select UI/PlayerBoxes/P1Box")
onready var VacantBox = get_parent().get_node("./CanvasLayer/Ready-Select UI/PlayerBoxes/VacantBox")
onready var P2Box = get_parent().get_node("./CanvasLayer/Ready-Select UI/PlayerBoxes/P2Box")
onready var P3Box = get_parent().get_node("./CanvasLayer/Ready-Select UI/PlayerBoxes/P3Box")
onready var P4Box = get_parent().get_node("./CanvasLayer/Ready-Select UI/PlayerBoxes/P4Box")

onready var P1Controller = get_parent().get_node("./CanvasLayer/Ready-Select UI/PlayerControllers/P1Controller")
onready var P1Keyboard = get_parent().get_node("./CanvasLayer/Ready-Select UI/PlayerControllers/P1Keyboard")
onready var P2Controller = get_parent().get_node("./CanvasLayer/Ready-Select UI/PlayerControllers/P2Controller")
onready var P2Keyboard = get_parent().get_node("./CanvasLayer/Ready-Select UI/PlayerControllers/P2Keyboard")
onready var P3Controller = get_parent().get_node("./CanvasLayer/Ready-Select UI/PlayerControllers/P2Controller")
onready var P3Keyboard = get_parent().get_node("./CanvasLayer/Ready-Select UI/PlayerControllers/P2Keyboard")
onready var P4Controller = get_parent().get_node("./CanvasLayer/Ready-Select UI/PlayerControllers/P2Controller")
onready var P4Keyboard = get_parent().get_node("./CanvasLayer/Ready-Select UI/PlayerControllers/P2Keyboard")
onready var VacantController = get_parent().get_node("./CanvasLayer/Ready-Select UI/PlayerControllers/VacantController")


var num_players = 0
var num_characters = 0
var keyboardAvailable = true

var controllerPlayers = [null, null, null, null, null, null, null, null]
var controllerCharacters = []
var keyboardPlayer

# Colors:
# 0 = blue, 1 = red, 2 = green, 3 = yellow
var availColors = ["blue", "red", "green", "orange"]


# Called when the node enters the scene tree for the first time.
func _ready():
	print(get_parent())
	keyboardPlayer = PLAYER.instance()
	keyboardPlayer.setControls(-1, false)
	VacantBox.visible = true
	VacantController.visible = true
	
	
func _process(delta):
	if Input.is_action_just_pressed("debug_createPlayerKeyboard"):
		if (keyboardAvailable):
			add_character(keyboardPlayer)
	elif Input.is_action_just_pressed("debug_removePlayerKeyboard"):
		if (!keyboardAvailable):
			remove_character(keyboardPlayer)
	elif Input.is_action_just_pressed("controller_join_game_0"):
		add_character(controllerPlayers[0])
	elif Input.is_action_just_pressed("controller_join_game_1"):
		add_character(controllerPlayers[1])		
	elif Input.is_action_just_pressed("controller_join_game_2"):
		add_character(controllerPlayers[2])		
	elif Input.is_action_just_pressed("controller_join_game_3"):
		add_character(controllerPlayers[3])		
	elif Input.is_action_just_pressed("controller_join_game_4"):
		add_character(controllerPlayers[4])
	elif Input.is_action_just_pressed("controller_join_game_5"):
		add_character(controllerPlayers[5])		
	elif Input.is_action_just_pressed("controller_join_game_6"):
		add_character(controllerPlayers[6])		
	elif Input.is_action_just_pressed("controller_join_game_7"):
		add_character(controllerPlayers[7])			
	elif Input.is_action_just_pressed("controller_leave_game_0"):
		remove_character(controllerPlayers[0])
	elif Input.is_action_just_pressed("controller_leave_game_1"):
		remove_character(controllerPlayers[1])		
	elif Input.is_action_just_pressed("controller_leave_game_2"):
		remove_character(controllerPlayers[2])		
	elif Input.is_action_just_pressed("controller_leave_game_3"):
		remove_character(controllerPlayers[3])		
	elif Input.is_action_just_pressed("controller_leave_game_4"):
		remove_character(controllerPlayers[4])
	elif Input.is_action_just_pressed("controller_leave_game_5"):
		remove_character(controllerPlayers[5])		
	elif Input.is_action_just_pressed("controller_leave_game_6"):
		remove_character(controllerPlayers[6])		
	elif Input.is_action_just_pressed("controller_leave_game_7"):
		remove_character(controllerPlayers[7])	
	
	
func add_character(player):		
	for character in controllerCharacters:
		if character == player:
			return
	if (controllerCharacters.size() + int(!keyboardAvailable) >= 4):
		return
	get_parent().add_child(player)
	
	
	var color = availColors.pop_front()
	if (color == "blue"):
		player.get_node("PlayerSprite").set_texture(blueHoodSprite)
		player.color = "blue"
		P1Box.visible = true
		if player == keyboardPlayer:
			P1Keyboard.visible = true
		else:
			P1Controller.visible = true
		orderToLast(P1Box)
		orderToLast(P1Keyboard)
		orderToLast(P1Controller)
	elif (color == "red"):
		player.get_node("PlayerSprite").set_texture(redHoodSprite)
		player.color = "red"
		P2Box.visible = true
		if player == keyboardPlayer:
			P2Keyboard.visible = true
		else:
			P2Controller.visible = true			
		orderToLast(P2Box)
		orderToLast(P2Keyboard)
		orderToLast(P2Controller)		
	elif (color == "green"):
		player.get_node("PlayerSprite").set_texture(greenHoodSprite)
		player.color = "green"
		P3Box.visible = true
		if player == keyboardPlayer:
			P3Keyboard.visible = true
		else:
			P3Controller.visible = true		
		orderToLast(P3Box)
		orderToLast(P3Keyboard)
		orderToLast(P3Controller)					
	elif (color == "orange"):
		player.get_node("PlayerSprite").set_texture(orangeHoodSprite)
		player.color = "orange"
		P4Box.visible = true
		if player == keyboardPlayer:
			P4Keyboard.visible = true
		else:
			P4Controller.visible = true		
		orderToLast(P4Box)
		orderToLast(P4Keyboard)
		orderToLast(P4Controller)		
	orderToLast(VacantBox)
	orderToLast(VacantController)
			
	match num_characters:
		0:
			# Player 1 Behaviours
			player.global_position = SpawnPoint1.global_position
		1:
			# Player 2 Behaviours
			player.global_position = SpawnPoint2.global_position
			VacantBox.visible = false
			VacantController.visible = false
			
		2:
			# Player 3 Behaviours
			player.global_position = SpawnPoint3.global_position
		3:
			# Player 4 Behaviours
			player.global_position = SpawnPoint4.global_position
			
	num_characters += 1
	if keyboardPlayer != player:
		controllerCharacters.push_back(player)
	else:
		keyboardAvailable = false
	print("player " + var2str(num_characters) + " spawned")

func remove_character(player):
	if num_characters == 2:
		VacantController.visible = true
		VacantBox.visible = true
	orderToLast(VacantController)
	orderToLast(VacantBox)

	var keyboardRemoval = (player == keyboardPlayer)
	match player.color:
		"blue":
			P1Box.visible = false
			if keyboardRemoval:
				P1Keyboard.visible = false
			else:
				P1Controller.visible = false
		"red":
			P2Box.visible = false
			if keyboardRemoval:
				P2Keyboard.visible = false
			else:
				P2Controller.visible = false
		"green":
			P3Box.visible = false
			if keyboardRemoval:
				P3Keyboard.visible = false
			else:
				P3Controller.visible = false
		"orange":
			P4Box.visible = false
			if keyboardRemoval:
				P4Keyboard.visible = false
			else:
				P4Controller.visible = false			
			
	if keyboardRemoval:
		availColors.push_front(player.color)
		get_parent().remove_child(player)
		num_characters -= 1
		keyboardAvailable = true
		return
		
	for character in controllerCharacters:
		if character == player:
			availColors.push_front(player.color)
			get_parent().remove_child(player)
			num_characters -= 1
			controllerCharacters.erase(player)
			return
			

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
	availColors.push_front(player.color)
	player.queue_free()
	controllerPlayers[id] = null
	num_players -= 1
	
	
func orderToLast(node):
	node.get_parent().move_child(node, node.get_parent().get_child_count() - 1)

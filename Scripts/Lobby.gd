extends Node

const PLAYER = preload("res://Scenes/Player.tscn")

const blueHoodHead = preload("res://Sprites/HUD Elements/PlayerSilhouttes/blueHoodHead.png")
const redHoodHead = preload("res://Sprites/HUD Elements/PlayerSilhouttes/redHoodHead.png")
const greenHoodHead = preload("res://Sprites/HUD Elements/PlayerSilhouttes/greenHoodHead.png")
const orangeHoodHead = preload("res://Sprites/HUD Elements/PlayerSilhouttes/orangeHoodHead.png")

const controllerSprite = preload("res://Sprites/HUD Elements/ControllerType/controller.png")
const keyboardSprite = preload("res://Sprites/HUD Elements/ControllerType/keyboard.png")

onready var SpawnPoint1 = get_parent().get_node("./PlayerSpawnPoints/Spawn Point 1")
onready var SpawnPoint2 = get_parent().get_node("./PlayerSpawnPoints/Spawn Point 2")
onready var SpawnPoint3 = get_parent().get_node("./PlayerSpawnPoints/Spawn Point 3")
onready var SpawnPoint4 = get_parent().get_node("./PlayerSpawnPoints/Spawn Point 4")

onready var P1Box = get_parent().get_node("./CanvasLayer/Ready-Select UI/PlayerBoxes/P1Box")
onready var VacantBox = get_parent().get_node("./CanvasLayer/Ready-Select UI/PlayerBoxes/VacantBox")
onready var P2Box = get_parent().get_node("./CanvasLayer/Ready-Select UI/PlayerBoxes/P2Box")
onready var P3Box = get_parent().get_node("./CanvasLayer/Ready-Select UI/PlayerBoxes/P3Box")
onready var P4Box = get_parent().get_node("./CanvasLayer/Ready-Select UI/PlayerBoxes/P4Box")

onready var P1Head = get_parent().get_node("./CanvasLayer/Ready-Select UI/PlayerHeads/P1Head")
onready var VacantHead = get_parent().get_node("./CanvasLayer/Ready-Select UI/PlayerHeads/VacantHead")
onready var P2Head = get_parent().get_node("./CanvasLayer/Ready-Select UI/PlayerHeads/P2Head")
onready var P3Head = get_parent().get_node("./CanvasLayer/Ready-Select UI/PlayerHeads/P3Head")
onready var P4Head = get_parent().get_node("./CanvasLayer/Ready-Select UI/PlayerHeads/P4Head")

onready var P1Controller = get_parent().get_node("./CanvasLayer/Ready-Select UI/PlayerControllers/P1Controller")
onready var P2Controller = get_parent().get_node("./CanvasLayer/Ready-Select UI/PlayerControllers/P2Controller")
onready var P3Controller = get_parent().get_node("./CanvasLayer/Ready-Select UI/PlayerControllers/P2Controller")
onready var P4Controller = get_parent().get_node("./CanvasLayer/Ready-Select UI/PlayerControllers/P2Controller")
onready var VacantController = get_parent().get_node("./CanvasLayer/Ready-Select UI/PlayerControllers/VacantController")


var num_players = 0
var num_characters = 0
var keyboardAvailable = true

var controllerPlayers = [null, null, null, null, null, null, null, null]
var controllerCharacters = []
var keyboardPlayer

var allCharacters = [null, null, null, null]

# Colors:
# 0 = blue, 1 = red, 2 = green, 3 = yellow
const colors = ["blue", "red", "green", "orange"]
# If availableColors[x] = 1, that means the color is avaialable. If it equals 0, not available.
# availableColors[0] = blue, 1 = red, 2 = green, 3 = yellow
var availableColors = {"hood": [1, 1, 1, 1]}

var headSprites

# Called when the node enters the scene tree for the first time.
func _ready():
	print(get_parent())
	keyboardPlayer = PLAYER.instance()
	keyboardPlayer.setControls(-1, false)
	VacantBox.visible = true
	VacantController.visible = true
	VacantHead.visible = true
	headSprites = {"hood": [blueHoodHead, redHoodHead, greenHoodHead, orangeHoodHead]}
	
	
func _process(delta):
	if Input.is_action_just_pressed("keyboard_jump"):
		if (keyboardAvailable):
			add_character(keyboardPlayer)
	if Input.is_action_just_pressed("debug_removePlayerKeyboard"):
		if (!keyboardAvailable):
			remove_character(keyboardPlayer)
	if Input.is_action_just_pressed("debug_change_color_keyboard"):
		if (!keyboardAvailable):
			change_color(keyboardPlayer)
			
	if (controllerPlayers[0] != null):
		if Input.is_action_just_pressed("controller_join_game_0"):
			add_character(controllerPlayers[0])
		if Input.is_action_just_pressed("controller_leave_game_0"):
			remove_character(controllerPlayers[0])
		if Input.is_action_just_pressed("debug_change_color_0"):
			change_color(controllerPlayers[0])		
	if (controllerPlayers[1] != null):
		if Input.is_action_just_pressed("controller_join_game_1"):
			add_character(controllerPlayers[1])
		if Input.is_action_just_pressed("controller_leave_game_1"):
			remove_character(controllerPlayers[1])
		if Input.is_action_just_pressed("debug_change_color_1"):
			change_color(controllerPlayers[1])	
	if (controllerPlayers[2] != null):
		if Input.is_action_just_pressed("controller_join_game_2"):
			add_character(controllerPlayers[2])
		if Input.is_action_just_pressed("controller_leave_game_2"):
			remove_character(controllerPlayers[2])
		if Input.is_action_just_pressed("debug_change_color_2"):
			change_color(controllerPlayers[2])		
	if (controllerPlayers[3] != null):
		if Input.is_action_just_pressed("controller_join_game_3"):
			add_character(controllerPlayers[3])
		if Input.is_action_just_pressed("controller_leave_game_3"):
			remove_character(controllerPlayers[3])
		if Input.is_action_just_pressed("debug_change_color_3"):
			change_color(controllerPlayers[3])	
	if (controllerPlayers[4] != null):
		if Input.is_action_just_pressed("controller_join_game_4"):
			add_character(controllerPlayers[4])
		if Input.is_action_just_pressed("controller_leave_game_4"):
			remove_character(controllerPlayers[4])
		if Input.is_action_just_pressed("debug_change_color_4"):
			change_color(controllerPlayers[4])		
	if (controllerPlayers[5] != null):
		if Input.is_action_just_pressed("controller_join_game_5"):
			add_character(controllerPlayers[5])
		if Input.is_action_just_pressed("controller_leave_game_5"):
			remove_character(controllerPlayers[5])
		if Input.is_action_just_pressed("debug_change_color_5"):
			change_color(controllerPlayers[5])		
	if (controllerPlayers[6] != null):
		if Input.is_action_just_pressed("controller_join_game_6"):
			add_character(controllerPlayers[6])
		if Input.is_action_just_pressed("controller_leave_game_6"):
			remove_character(controllerPlayers[6])
		if Input.is_action_just_pressed("debug_change_color_6"):
			change_color(controllerPlayers[6])		
	if (controllerPlayers[7] != null):
		if Input.is_action_just_pressed("controller_join_game_7"):
			add_character(controllerPlayers[7])
		if Input.is_action_just_pressed("controller_leave_game_7"):
			remove_character(controllerPlayers[7])
		if Input.is_action_just_pressed("debug_change_color_7"):
			change_color(controllerPlayers[7])																										
									
		
	
	
func add_character(player):		
	print("adding character")
	for character in controllerCharacters:
		if character == player:
			return
	if (controllerCharacters.size() + int(!keyboardAvailable) >= 4):
		return
	get_parent().add_child(player)
	var charClass = "hood"
	player.change_class(charClass)
	var colorIndex

	for i in range(0,3):
		if availableColors[charClass][i] == 1:
			availableColors[charClass][i] = 0
			colorIndex = i
			match i:
				0:
					player.change_color("blue")
				1:
					player.change_color("red")
				2:
					player.change_color("green")						
				3:	
					player.change_color("orange")	
			break
		assert( i != 3, "ERROR: No available colors")
			
	match num_characters:
		0:
			# Player 1 Behaviours
			player.number = 1
			player.global_position = SpawnPoint1.global_position
			
			P1Head.set_texture(headSprites[player.charClass][colorIndex])
			P1Head.visible = true
			P1Box.visible = true
			P1Controller.visible = true
			if player == keyboardPlayer:
				P1Controller.set_texture(keyboardSprite)
			else:
				P1Controller.set_texture(controllerSprite)
			allCharacters[0] = player
		1:
			# Player 2 Behaviours
			VacantBox.visible = false
			VacantController.visible = false
			VacantHead.visible = false
			
			player.number = 2
			player.global_position = SpawnPoint2.global_position			
			P2Head.set_texture(headSprites[player.charClass][colorIndex])
			P2Head.visible = true
			P2Box.visible = true
			P2Controller.visible = true
			if player == keyboardPlayer:
				P2Controller.set_texture(keyboardSprite)
			else:
				P2Controller.set_texture(controllerSprite)
			allCharacters[1] = player
		2:
			# Player 3 Behaviours
			player.number = 3
			player.global_position = SpawnPoint3.global_position
			P3Head.set_texture(headSprites[player.charClass][colorIndex])
			P3Head.visible = true
			P3Box.visible = true
			P3Controller.visible = true
			if player == keyboardPlayer:
				P3Controller.set_texture(keyboardSprite)
			else:
				P3Controller.set_texture(controllerSprite)
			allCharacters[2] = player
		3:
			# Player 4 Behaviours
			player.number = 4
			player.global_position = SpawnPoint4.global_position
			P4Head.set_texture(headSprites[player.charClass][colorIndex])
			P4Head.visible = true			
			P4Box.visible = true
			P4Controller.visible = true
			if player == keyboardPlayer:
				P4Controller.set_texture(keyboardSprite)
			else:
				P4Controller.set_texture(controllerSprite)
			allCharacters[3] = player			
			
	num_characters += 1
	if keyboardPlayer != player:
		controllerCharacters.push_back(player)
	else:
		keyboardAvailable = false
	print("player " + var2str(num_characters) + " spawned")

func remove_character(player):
	var keyboardRemoval = (player == keyboardPlayer)
	if keyboardRemoval:
		keyboardAvailable = true
	else:
		if controllerCharacters.has(player):
			controllerCharacters.erase(player)
		else:
			return
	if num_characters == 2:
		VacantController.visible = true
		VacantBox.visible = true		
		VacantHead.visible = true	
		
	match player.color:
		"blue":
			availableColors[player.charClass][0] = 1
		"red":
			availableColors[player.charClass][1] = 1
		"green":
			availableColors[player.charClass][2] = 1
		"orange":
			availableColors[player.charClass][3] = 1
			
	match num_characters:
		1:
			P1Box.visible = false
			P1Head.visible = false
			P1Controller.visible = false
			allCharacters[0] = null
		2:		
			match player.number:
				1:
					allCharacters[0] = allCharacters[1]
					allCharacters[0].number = 1
					P1Head.set_texture(P2Head.get_texture())
					P1Controller.set_texture(P2Controller.get_texture())
				2:
					pass
			P2Box.visible = false
			P2Head.visible = false		
			P2Controller.visible = false
			allCharacters[1] = null
		3:
			match player.number:
				1:
					allCharacters[0] = allCharacters[1]
					allCharacters[0].number = 1
					P1Head.set_texture(P2Head.get_texture())
					P1Controller.set_texture(P2Controller.get_texture())
				1,2:
					allCharacters[1] = allCharacters[2]
					allCharacters[1].number = 2
					P2Head.set_texture(P3Head.get_texture())
					P2Controller.set_texture(P3Controller.get_texture())					
				3:
					pass
			P3Box.visible = false
			P3Head.visible = false		
			P3Controller.visible = false
			allCharacters[2] = null
		4:
			match player.number:
				1:
					allCharacters[0] = allCharacters[1]
					allCharacters[0].number = 1
					P1Head.set_texture(P2Head.get_texture())
					P1Controller.set_texture(P2Controller.get_texture())
				1,2:
					allCharacters[1] = allCharacters[2]
					allCharacters[1].number = 2
					P2Head.set_texture(P3Head.get_texture())
					P2Controller.set_texture(P3Controller.get_texture())					
				1,2,3:
					allCharacters[2] = allCharacters[3]
					allCharacters[2].number = 3
					P3Head.set_texture(P4Head.get_texture())
					P3Controller.set_texture(P4Controller.get_texture())	
				4:
					pass
			P4Box.visible = false
			P4Head.visible = false		
			P4Controller.visible = false
			allCharacters[3] = null			
	player.number = -1
	player.charClass = ""
	get_parent().remove_child(player)
	num_characters -= 1
	
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
	for character in controllerCharacters:
		if player == character:
			remove_character(player)
	player.queue_free()
	controllerPlayers[id] = null
	num_players -= 1
	
	
func change_color(player):
	
	for character in controllerCharacters:
		if character == player || keyboardPlayer == player:
			#Valid player
			var charClass = player.charClass
			var initialColor = player.color
			var colorIndex
			match initialColor:
				"blue":
					colorIndex = 0
				"red":
					colorIndex = 1
				"green":
					colorIndex = 2
				"orange":
					colorIndex = 3
			var i = colorIndex + 1
			if (i == 4):
				i = 0
			while (i != colorIndex):
				if availableColors[charClass][i] == 1:
					availableColors[charClass][colorIndex] = 1
					availableColors[charClass][i] = 0					
					match i:
						0:
							player.change_color("blue")
						1:
							player.change_color("red")
						2:
							player.change_color("green")						
						3:	
							player.change_color("orange")
					match player.number:
						1:
							P1Head.set_texture(headSprites[player.charClass][i])
						2:
							P2Head.set_texture(headSprites[player.charClass][i])
						3:
							P3Head.set_texture(headSprites[player.charClass][i])
						4:			
							P4Head.set_texture(headSprites[player.charClass][i])
					return	
				i += 1
				if (i == 4):
					i = 0
			#Return if there are no available colors for this player's class.					
			return											
	

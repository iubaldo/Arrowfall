extends Node

var keyboard_move_up = "W"
var keyboard_move_down = "S"
var keyboard_move_left = "A"
var keyboard_move_right = "D"

var keyboard_jump = "Space"
var keyboard_fire = "Left Button"
var keyboard_shield = "Right Button"
var keyboard_item = "Shift"
var keyboard_pause = "Escape"


var controller_move_up = "Axis 1 -"
var controller_move_down = "Axis 1 +"
var controller_move_left = "Axis 0 -"
var controller_move_right = "Axis 0 +"

var controller_aim_up = "Axis 3 -"
var controller_aim_down = "Axis 3 +"
var controller_aim_left = "Axis 2 -"
var controller_aim_right = "Axis 2 +"

var controller_jump = "4"
var controller_fire = "5"
var controller_shield = "7"
var controller_item = "6"
var controller_pause = "11"


var player_1_controller = {  'type': 'keyboard', 'id': 0, 'name': 'player1' }

var player_2_controller = {  'type': 'keyboard', 'id': 1, 'name': 'player2' }

var player_3_controller = {  'type': 'keyboard', 'id': 2, 'name': 'player3' }

var player_4_controller = {  'type': 'keyboard', 'id': 3, 'name': 'player4' }

var players = [player_1_controller, player_2_controller, player_3_controller, player_4_controller]
var numPlayers = 2

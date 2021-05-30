extends Node

func _ready():
	var PlayGame = get_parent().get_node("MarginContainer/Options/Play")
	PlayGame.connect("pressed", self, "_start_game")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _start_game():
	Main.change_screen("Lobby")

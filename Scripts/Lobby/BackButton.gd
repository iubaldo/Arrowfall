extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var presserId = -1

var isBeingPressed = false
onready var BackAnimation = get_node("BackAnimation")

#The id number is the id of the thing doing the pressing. 0-7 = corresponding device.
# 8 = mouse cancel. 9 = escape button
func bePressed(id):
	if !isBeingPressed:
		presserId = id
		isBeingPressed = true
		BackAnimation.play("BackOut", false)

func beReleased(id):
	if (presserId == id):
		print("released")
		presserId = -1
		isBeingPressed = false
		BackAnimation.frame = 0
		BackAnimation.playing = false

var timer : float

func _process(delta):
	#print(isBeingPressed)
	if timer >= .70:
		BackAnimation.frame = 0
		Main.change_screen("Main Menu")
	elif (isBeingPressed):
		timer += delta
	else:
		timer = 0

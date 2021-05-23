extends Node

class_name controlInput

signal keyboard_command(input_name)
signal controller_command(input_name, device_id)
signal controller_stick_command(input_name, action_strength, device_id)

func _process(delta):
	get_input()
	
func get_input():
	
	# Keyboard Inputs
	if Input.is_action_pressed("keyboard_move_up"):
		emit_signal("keyboard_command", 'keyboard_move_up')
	if Input.is_action_pressed("keyboard_move_down"):
		emit_signal("keyboard_command", 'keyboard_move_down')
	if Input.is_action_pressed("keyboard_move_left"):
		emit_signal("keyboard_command", 'keyboard_move_left')
	if Input.is_action_pressed("keyboard_move_right"):
		emit_signal("keyboard_command", 'keyboard_move_right')
		
	if Input.is_action_just_pressed("keyboard_jump"):
		emit_signal("keyboard_command", 'keyboard_jump')
	if Input.is_action_just_pressed("keyboard_fire"):
		emit_signal("keyboard_command", 'keyboard_fire')
	if Input.is_action_just_pressed("keyboard_shield"):
		emit_signal("keyboard_command", 'keyboard_shield')
	if Input.is_action_just_pressed("keyboard_item"):
		emit_signal("keyboard_command", 'keyboard_item')
	if Input.is_action_just_pressed("keyboard_pause"):
		emit_signal("keyboard_command", 'keyboard_pause')
		
	
	# Controller 0 Inputs
	if Input.get_action_strength("controller_move_up_0") > 0.5:
		emit_signal("controller_stick_command", 'controller_move_up_0', Input.get_action_strength("controller_move_up_0"), 0)
	if Input.get_action_strength("controller_move_down_0") > 0.5:
		emit_signal("controller_stick_command", 'controller_move_down_0', Input.get_action_strength("controller_move_down_0"), 0)
	if Input.get_action_strength("controller_move_left_0") > 0.5:
		emit_signal("controller_stick_command", 'controller_move_left_0', Input.get_action_strength("controller_move_left_0"), 0)
	if Input.get_action_strength("controller_move_right_0") > 0.5:
		emit_signal("controller_stick_command", 'controller_move_right_0', Input.get_action_strength("controller_move_right_0"), 0)
		
	if Input.get_action_strength("controller_aim_up_0") > 0.5:
		emit_signal("controller_stick_command", 'controller_aim_up_0', Input.get_action_strength("controller_aim_up_0"), 0)
	if Input.get_action_strength("controller_aim_down_0") > 0.5:
		emit_signal("controller_stick_command", 'controller_aim_down_0', Input.get_action_strength("controller_aim_down_0"), 0)
	if Input.get_action_strength("controller_aim_left_0") > 0.5:
		emit_signal("controller_stick_command", 'controller_aim_left_0', Input.get_action_strength("controller_aim_left_0"), 0)
	if Input.get_action_strength("controller_aim_right_0") > 0.5:
		emit_signal("controller_stick_command", 'controller_aim_right_0', Input.get_action_strength("controller_aim_right_0"), 0)
		
	if Input.is_action_just_pressed("controller_jump_0"):
		emit_signal("controller_command", 'controller_jump_0', 0)
	if Input.is_action_just_pressed("controller_fire_0"):
		emit_signal("controller_command", 'controller_fire_0', 0)
	if Input.is_action_just_pressed("controller_shield_0"):
		emit_signal("controller_command", 'controller_shield_0', 0)
	if Input.is_action_just_pressed("controller_item_0"):
		emit_signal("controller_command", 'controller_item_0', 0)
	if Input.is_action_just_pressed("controller_pause_0"):
		emit_signal("controller_command", 'controller_pause_0', 0)
	if Input.is_action_just_pressed("controller_join_game_0"):
		emit_signal("controller_command", 'controller_join_game_0', 0)		
	
	
	# Controller 1 Inputs
	if Input.get_action_strength("controller_move_up_1") > 0.5:
		emit_signal("controller_stick_command", 'controller_move_up_1', Input.get_action_strength("controller_move_up_1"), 1)
	if Input.get_action_strength("controller_move_down_1") > 0.5:
		emit_signal("controller_stick_command", 'controller_move_down_1', Input.get_action_strength("controller_move_down_1"), 1)
	if Input.get_action_strength("controller_move_left_1") > 0.5:
		emit_signal("controller_stick_command", 'controller_move_left_1', Input.get_action_strength("controller_move_left_1"), 1)
	if Input.get_action_strength("controller_move_right_1") > 0.5:
		emit_signal("controller_stick_command", 'controller_move_right_1', Input.get_action_strength("controller_move_right_1"), 1)
		
	if Input.get_action_strength("controller_aim_up_1") > 0.5:
		emit_signal("controller_stick_command", 'controller_aim_up_1', Input.get_action_strength("controller_aim_up_1"), 1)
	if Input.get_action_strength("controller_aim_down_1") > 0.5:
		emit_signal("controller_stick_command", 'controller_aim_down_1', Input.get_action_strength("controller_aim_down_1"), 1)
	if Input.get_action_strength("controller_aim_left_1") > 0.5:
		emit_signal("controller_stick_command", 'controller_aim_left_1', Input.get_action_strength("controller_aim_left_1"), 1)
	if Input.get_action_strength("controller_aim_right_1") > 0.5:
		emit_signal("controller_stick_command", 'controller_aim_right_1', Input.get_action_strength("controller_aim_right_1"), 1)
		
	if Input.is_action_just_pressed("controller_jump_1"):
		emit_signal("controller_command", 'controller_jump_1', 1)
	if Input.is_action_just_pressed("controller_fire_1"):
		emit_signal("controller_command", 'controller_fire_1', 1)
	if Input.is_action_just_pressed("controller_shield_1"):
		emit_signal("controller_command", 'controller_shield_1', 1)
	if Input.is_action_just_pressed("controller_item_1"):
		emit_signal("controller_command", 'controller_item_1', 1)
	if Input.is_action_just_pressed("controller_pause_1"):
		emit_signal("controller_command", 'controller_pause_1', 1)
	if Input.is_action_just_pressed("controller_join_game_1"):
		emit_signal("controller_command", 'controller_join_game_1', 1)			
		
	
	# Controller 2 Inputs
	if Input.get_action_strength("controller_move_up_2") > 0.5:
		emit_signal("controller_stick_command", 'controller_move_up_2', Input.get_action_strength("controller_move_up_2"), 2)
	if Input.get_action_strength("controller_move_down_2") > 0.5:
		emit_signal("controller_stick_command", 'controller_move_down_2', Input.get_action_strength("controller_move_down_2"), 2)
	if Input.get_action_strength("controller_move_left_2") > 0.5:
		emit_signal("controller_stick_command", 'controller_move_left_2', Input.get_action_strength("controller_move_left_2"), 2)
	if Input.get_action_strength("controller_move_right_2") > 0.5:
		emit_signal("controller_stick_command", 'controller_move_right_2', Input.get_action_strength("controller_move_right_2"), 2)
		
	if Input.get_action_strength("controller_aim_up_2") > 0.5:
		emit_signal("controller_stick_command", 'controller_aim_up_2', Input.get_action_strength("controller_aim_up_2"), 2)
	if Input.get_action_strength("controller_aim_down_2") > 0.5:
		emit_signal("controller_stick_command", 'controller_aim_down_2', Input.get_action_strength("controller_aim_down_2"), 2)
	if Input.get_action_strength("controller_aim_left_2") > 0.5:
		emit_signal("controller_stick_command", 'controller_aim_left_2', Input.get_action_strength("controller_aim_left_2"), 2)
	if Input.get_action_strength("controller_aim_right_2") > 0.5:
		emit_signal("controller_stick_command", 'controller_aim_right_2', Input.get_action_strength("controller_aim_right_2"), 2)
		
	if Input.is_action_just_pressed("controller_jump_2"):
		emit_signal("controller_command", 'controller_jump_2', 2)
	if Input.is_action_just_pressed("controller_fire_2"):
		emit_signal("controller_command", 'controller_fire_2', 2)
	if Input.is_action_just_pressed("controller_shield_2"):
		emit_signal("controller_command", 'controller_shield_2', 2)
	if Input.is_action_just_pressed("controller_item_2"):
		emit_signal("controller_command", 'controller_item_2', 2)
	if Input.is_action_just_pressed("controller_pause_2"):
		emit_signal("controller_command", 'controller_pause_2', 2)
	if Input.is_action_just_pressed("controller_join_game_2"):
		emit_signal("controller_command", 'controller_join_game_2', 2)			
		
		
	# Controller 3 Inputs
	if Input.get_action_strength("controller_move_up_3") > 0.5:
		emit_signal("controller_stick_command", 'controller_move_up_3', Input.get_action_strength("controller_move_up_3"), 3)
	if Input.get_action_strength("controller_move_down_3") > 0.5:
		emit_signal("controller_stick_command", 'controller_move_down_3', Input.get_action_strength("controller_move_down_3"), 3)
	if Input.get_action_strength("controller_move_left_3") > 0.5:
		emit_signal("controller_stick_command", 'controller_move_left_3', Input.get_action_strength("controller_move_left_3"), 3)
	if Input.get_action_strength("controller_move_right_3") > 0.5:
		emit_signal("controller_stick_command", 'controller_move_right_3', Input.get_action_strength("controller_move_right_3"), 3)
		
	if Input.get_action_strength("controller_aim_up_3") > 0.5:
		emit_signal("controller_stick_command", 'controller_aim_up_3', Input.get_action_strength("controller_aim_up_3"), 3)
	if Input.get_action_strength("controller_aim_down_3") > 0.5:
		emit_signal("controller_stick_command", 'controller_aim_down_3', Input.get_action_strength("controller_aim_down_3"), 3)
	if Input.get_action_strength("controller_aim_left_3") > 0.5:
		emit_signal("controller_stick_command", 'controller_aim_left_3', Input.get_action_strength("controller_aim_left_3"), 3)
	if Input.get_action_strength("controller_aim_right_3") > 0.5:
		emit_signal("controller_stick_command", 'controller_aim_right_3', Input.get_action_strength("controller_aim_right_3"), 3)
		
	if Input.is_action_just_pressed("controller_jump_3"):
		emit_signal("controller_command", 'controller_jump_3', 3)
	if Input.is_action_just_pressed("controller_fire_3"):
		emit_signal("controller_command", 'controller_fire_3', 3)
	if Input.is_action_just_pressed("controller_shield_3"):
		emit_signal("controller_command", 'controller_shield_3', 3)
	if Input.is_action_just_pressed("controller_item_3"):
		emit_signal("controller_command", 'controller_item_3', 3)
	if Input.is_action_just_pressed("controller_pause_3"):
		emit_signal("controller_command", 'controller_pause_3', 3)
	if Input.is_action_just_pressed("controller_join_game_3"):
		emit_signal("controller_command", 'controller_join_game_3', 3)	
		
		
	# Controller 4 Inputs
	if Input.get_action_strength("controller_move_up_4") > 0.5:
		emit_signal("controller_stick_command", 'controller_move_up_4', Input.get_action_strength("controller_move_up_4"), 4)
	if Input.get_action_strength("controller_move_down_4") > 0.5:
		emit_signal("controller_stick_command", 'controller_move_down_4', Input.get_action_strength("controller_move_down_4"), 4)
	if Input.get_action_strength("controller_move_left_4") > 0.5:
		emit_signal("controller_stick_command", 'controller_move_left_4', Input.get_action_strength("controller_move_left_4"), 4)
	if Input.get_action_strength("controller_move_right_4") > 0.5:
		emit_signal("controller_stick_command", 'controller_move_right_4', Input.get_action_strength("controller_move_right_4"), 4)
		
	if Input.get_action_strength("controller_aim_up_4") > 0.5:
		emit_signal("controller_stick_command", 'controller_aim_up_4', Input.get_action_strength("controller_aim_up_4"), 4)
	if Input.get_action_strength("controller_aim_down_4") > 0.5:
		emit_signal("controller_stick_command", 'controller_aim_down_4', Input.get_action_strength("controller_aim_down_4"), 4)
	if Input.get_action_strength("controller_aim_left_4") > 0.5:
		emit_signal("controller_stick_command", 'controller_aim_left_4', Input.get_action_strength("controller_aim_left_4"), 4)
	if Input.get_action_strength("controller_aim_right_4") > 0.5:
		emit_signal("controller_stick_command", 'controller_aim_right_4', Input.get_action_strength("controller_aim_right_4"), 4)
		
	if Input.is_action_just_pressed("controller_jump_4"):
		emit_signal("controller_command", 'controller_jump_4', 4)
	if Input.is_action_just_pressed("controller_fire_4"):
		emit_signal("controller_command", 'controller_fire_4', 4)
	if Input.is_action_just_pressed("controller_shield_4"):
		emit_signal("controller_command", 'controller_shield_4', 4)
	if Input.is_action_just_pressed("controller_item_4"):
		emit_signal("controller_command", 'controller_item_4', 4)
	if Input.is_action_just_pressed("controller_pause_4"):
		emit_signal("controller_command", 'controller_pause_4', 4)
	if Input.is_action_just_pressed("controller_join_game_4"):
		emit_signal("controller_command", 'controller_join_game_4', 4)	
		
	# Controller 5 Inputs
	if Input.get_action_strength("controller_move_up_5") > 0.5:
		emit_signal("controller_stick_command", 'controller_move_up_5', Input.get_action_strength("controller_move_up_5"), 5)
	if Input.get_action_strength("controller_move_down_5") > 0.5:
		emit_signal("controller_stick_command", 'controller_move_down_5', Input.get_action_strength("controller_move_down_5"), 5)
	if Input.get_action_strength("controller_move_left_5") > 0.5:
		emit_signal("controller_stick_command", 'controller_move_left_5', Input.get_action_strength("controller_move_left_5"), 5)
	if Input.get_action_strength("controller_move_right_5") > 0.5:
		emit_signal("controller_stick_command", 'controller_move_right_5', Input.get_action_strength("controller_move_right_5"), 5)
		
	if Input.get_action_strength("controller_aim_up_5") > 0.5:
		emit_signal("controller_stick_command", 'controller_aim_up_5', Input.get_action_strength("controller_aim_up_5"), 5)
	if Input.get_action_strength("controller_aim_down_5") > 0.5:
		emit_signal("controller_stick_command", 'controller_aim_down_5', Input.get_action_strength("controller_aim_down_5"), 5)
	if Input.get_action_strength("controller_aim_left_5") > 0.5:
		emit_signal("controller_stick_command", 'controller_aim_left_5', Input.get_action_strength("controller_aim_left_5"), 5)
	if Input.get_action_strength("controller_aim_right_5") > 0.5:
		emit_signal("controller_stick_command", 'controller_aim_right_5', Input.get_action_strength("controller_aim_right_5"), 5)
		
	if Input.is_action_just_pressed("controller_jump_5"):
		emit_signal("controller_command", 'controller_jump_5', 5)
	if Input.is_action_just_pressed("controller_fire_5"):
		emit_signal("controller_command", 'controller_fire_5', 5)
	if Input.is_action_just_pressed("controller_shield_5"):
		emit_signal("controller_command", 'controller_shield_5', 5)
	if Input.is_action_just_pressed("controller_item_5"):
		emit_signal("controller_command", 'controller_item_5', 5)
	if Input.is_action_just_pressed("controller_pause_5"):
		emit_signal("controller_command", 'controller_pause_5', 5)
	if Input.is_action_just_pressed("controller_join_game_5"):
		emit_signal("controller_command", 'controller_join_game_5', 5)	
				

	# Controller 6 Inputs
	if Input.get_action_strength("controller_move_up_6") > 0.5:
		emit_signal("controller_stick_command", 'controller_move_up_6', Input.get_action_strength("controller_move_up_6"), 6)
	if Input.get_action_strength("controller_move_down_6") > 0.5:
		emit_signal("controller_stick_command", 'controller_move_down_6', Input.get_action_strength("controller_move_down_6"), 6)
	if Input.get_action_strength("controller_move_left_6") > 0.5:
		emit_signal("controller_stick_command", 'controller_move_left_6', Input.get_action_strength("controller_move_left_6"), 6)
	if Input.get_action_strength("controller_move_right_6") > 0.5:
		emit_signal("controller_stick_command", 'controller_move_right_6', Input.get_action_strength("controller_move_right_6"), 6)
		
	if Input.get_action_strength("controller_aim_up_6") > 0.5:
		emit_signal("controller_stick_command", 'controller_aim_up_6', Input.get_action_strength("controller_aim_up_6"), 6)
	if Input.get_action_strength("controller_aim_down_6") > 0.5:
		emit_signal("controller_stick_command", 'controller_aim_down_6', Input.get_action_strength("controller_aim_down_6"), 6)
	if Input.get_action_strength("controller_aim_left_6") > 0.5:
		emit_signal("controller_stick_command", 'controller_aim_left_6', Input.get_action_strength("controller_aim_left_6"), 6)
	if Input.get_action_strength("controller_aim_right_6") > 0.5:
		emit_signal("controller_stick_command", 'controller_aim_right_6', Input.get_action_strength("controller_aim_right_6"), 6)
		
	if Input.is_action_just_pressed("controller_jump_6"):
		emit_signal("controller_command", 'controller_jump_6', 6)
	if Input.is_action_just_pressed("controller_fire_6"):
		emit_signal("controller_command", 'controller_fire_6', 6)
	if Input.is_action_just_pressed("controller_shield_6"):
		emit_signal("controller_command", 'controller_shield_6', 6)
	if Input.is_action_just_pressed("controller_item_6"):
		emit_signal("controller_command", 'controller_item_6', 6)
	if Input.is_action_just_pressed("controller_pause_6"):
		emit_signal("controller_command", 'controller_pause_6', 6)
	if Input.is_action_just_pressed("controller_join_game_6"):
		emit_signal("controller_command", 'controller_join_game_6', 6)	
		

	# Controller 7 Inputs
	if Input.get_action_strength("controller_move_up_7") > 0.5:
		emit_signal("controller_stick_command", 'controller_move_up_7', Input.get_action_strength("controller_move_up_7"), 7)
	if Input.get_action_strength("controller_move_down_7") > 0.5:
		emit_signal("controller_stick_command", 'controller_move_down_7', Input.get_action_strength("controller_move_down_7"), 7)
	if Input.get_action_strength("controller_move_left_7") > 0.5:
		emit_signal("controller_stick_command", 'controller_move_left_7', Input.get_action_strength("controller_move_left_7"), 7)
	if Input.get_action_strength("controller_move_right_7") > 0.5:
		emit_signal("controller_stick_command", 'controller_move_right_7', Input.get_action_strength("controller_move_right_7"), 7)
		
	if Input.get_action_strength("controller_aim_up_7") > 0.5:
		emit_signal("controller_stick_command", 'controller_aim_up_7', Input.get_action_strength("controller_aim_up_7"), 7)
	if Input.get_action_strength("controller_aim_down_7") > 0.5:
		emit_signal("controller_stick_command", 'controller_aim_down_7', Input.get_action_strength("controller_aim_down_7"), 7)
	if Input.get_action_strength("controller_aim_left_7") > 0.5:
		emit_signal("controller_stick_command", 'controller_aim_left_7', Input.get_action_strength("controller_aim_left_7"), 7)
	if Input.get_action_strength("controller_aim_right_7") > 0.5:
		emit_signal("controller_stick_command", 'controller_aim_right_7', Input.get_action_strength("controller_aim_right_7"), 7)
		
	if Input.is_action_just_pressed("controller_jump_7"):
		emit_signal("controller_command", 'controller_jump_7', 7)
	if Input.is_action_just_pressed("controller_fire_7"):
		emit_signal("controller_command", 'controller_fire_7', 7)
	if Input.is_action_just_pressed("controller_shield_7"):
		emit_signal("controller_command", 'controller_shield_7', 7)
	if Input.is_action_just_pressed("controller_item_7"):
		emit_signal("controller_command", 'controller_item_7', 7)
	if Input.is_action_just_pressed("controller_pause_7"):
		emit_signal("controller_command", 'controller_pause_7', 7)
	if Input.is_action_just_pressed("controller_join_game_7"):
		emit_signal("controller_command", 'controller_join_game_7', 7)	

func _input(event : InputEvent) -> void:
	if event is InputEventKey:
		handle_as_keyboard(event)
	elif event is InputEventJoypadButton:
		handle_as_controller(event)
		

func handle_as_keyboard(event: InputEventKey):
	pass
	
func handle_as_controller(event: InputEventJoypadButton):
	pass

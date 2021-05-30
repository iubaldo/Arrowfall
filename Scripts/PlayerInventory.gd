extends Node

var inventory = []

func addItem(item):
	if !inventory.empty:
		inventory.pop_front()
			
	inventory.push_back(item)

func dropItem(type):
	inventory.pop_front()

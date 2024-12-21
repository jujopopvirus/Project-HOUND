@icon("res://content/ui/godot_icons/character_stats2.svg")
class_name Character_Stats

extends Node

@export_category("Player Movement")
@export var SPRINT_speed = 18.0
@export var WALKING_speed  = 8.0
@export var JUMP_strength  = 6.0

@export_category("Player Stats")
@export var MAX_HEALTH  = 100.0
var CURRENT_HEALTH  = 100.0 : set = _set_maxhealth

func _set_maxhealth(new_hp: int) -> void:
	CURRENT_HEALTH = clamp(new_hp, 0, MAX_HEALTH)

@export var MAX_ENERGY  = 6.0

@export_category("Player Settings")
@export var MOUSE_SENSITIVITY := 0.5

@icon("res://content/ui/godot_icons/character_stats2.svg")
class_name In_Game_PlayerStats

extends Node

@export var CODENAME : String = "Doe"

@export_category("Player Stats")


@export var Player_Type : String = "SCOUT"

var SPEED : int = 6
var WALKING_speed  = SPEED
var SPRINT_speed = SPEED * 2
var JUMP_strength : int  = 8

var MAX_HEALTH : int = 100
var CURRENT_HEALTH : int  = 100 : set = _set_maxhealth
func _set_maxhealth(new_hp: int) -> void:
	CURRENT_HEALTH = clamp(new_hp, 0, MAX_HEALTH)
@export var MAX_STAMINA : int = 100

@export var STRENGTH : int = 6
@export var DEXTERITY : int = 6
@export var ENDURANCE : int = 6
@export var LUCK : int = 0

@export_category("Player Settings")
@export var MOUSE_SENSITIVITY := 0.5
@export var Player : Player_Controller

func _ready() -> void:
	GlobalGameManager.Update_InGame_Character_Stats(self)


func _set_up_character():
	match Player_Type:
		"SCOUT":
			update_playerstats("MAX_HEALTH", 60, true)
			update_playerstats("SPEED", 8)
		"GUARD":
			update_playerstats("MAX_HEALTH", 150, true)
			update_playerstats("SPEED", 6)
		"TANK":
			update_playerstats("MAX_HEALTH", 300, true)
			update_playerstats("SPEED", 4)
	
	Player._update_playerstats()


func update_playerstats(Stats_Replaced : String, InputReplacements : int, ReplaceStats : bool = false):
	match Stats_Replaced:
		"MAX_HEALTH":
			if ReplaceStats:
				MAX_HEALTH = InputReplacements
			else:
				MAX_HEALTH += InputReplacements
		"SPEED":
			if ReplaceStats:
				SPEED += InputReplacements
			else:
				SPEED = InputReplacements
			WALKING_speed  = SPEED
			SPRINT_speed = SPEED * 2

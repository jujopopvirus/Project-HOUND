@icon("res://content/ui/godot_icons/character_stats2.svg")
class_name Character_Stats

extends Node

@export var CODENAME : String = "Doe"
@export var GENDER : String = "Neutral"

@export_category("Player Stats")
enum Body_Type {
	SCOUT, #80 HP, 8 SPEED
	GUARD, #150 HP, 6 SPEED
	TANK #300 HP, 4 SPEED
}

@export var Player_Type : Body_Type

var SPEED : int = 0
var WALKING_speed  = SPEED
var SPRINT_speed = SPEED * 2
var JUMP_strength : int  = 6

var MAX_HEALTH : int = 100
var CURRENT_HEALTH : int  = 100 : set = _set_maxhealth
func _set_maxhealth(new_hp: int) -> void:
	CURRENT_HEALTH = clamp(new_hp, 0, MAX_HEALTH)
@export var MAX_STAMINA : int = 100

@export var STRENGTH : int = 6
@export var DEXTERITY : int = 6
@export var ENDURANCE : int = 6

@export_category("Player Settings")
@export var MOUSE_SENSITIVITY := 0.5
@export var Player : Player_Controller

func _ready() -> void:
	_set_up_character()
	Player._update_playerstats()


func _set_up_character():
	match Player_Type:
		Body_Type.SCOUT:
			update_playerstats("MAX_HEALTH", 60, true)
			update_playerstats("SPEED", 6)
		Body_Type.GUARD:
			update_playerstats("MAX_HEALTH", 150, true)
			update_playerstats("SPEED", 5)
		Body_Type.TANK:
			update_playerstats("MAX_HEALTH", 300, true)
			update_playerstats("SPEED", 3)


func update_playerstats(Stats_Replaced : String, InputReplacements : int, ReplaceStats : bool = false):
	match Stats_Replaced:
		"MAX_HEALTH":
			if ReplaceStats:
				MAX_HEALTH = InputReplacements
			else:
				MAX_HEALTH += InputReplacements
		"SPEED":
			SPEED += InputReplacements
			WALKING_speed  = SPEED
			SPRINT_speed = SPEED * 2

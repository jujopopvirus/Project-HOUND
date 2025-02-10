extends Node2D
class_name  Randomized_Character_Card

var SETUP_STATS : Player_Stats_Resource = Player_Stats_Resource.new()
var RNG = RandomNumberGenerator.new()

@onready var NAME_TEXT : Label = %NAME_LABEL
var CODENAME = SETUP_STATS.CODENAME.pick_random()

@onready var GENDER_TEXT : Label = %GENDER_LABEL
var GENDER = SETUP_STATS.Gender.pick_random()

@onready var STRENGTH_TEXT : Label = %STRENGTH_LABEL
var STRENGTH = SETUP_STATS.STRENGTH
@onready var ENDURANCE_TEXT : Label = %ENDURANCE_LABEL
var ENDURANCE = SETUP_STATS.ENDURANCE
@onready var DEXTERITY_TEXT : Label = %DEXTERITY_LABEL
var DEXTERITY = SETUP_STATS.DEXTERITY

@onready var ROLE_TEXT : Label = %ROLE_LABEL
var ROLE = SETUP_STATS.Body_Type.pick_random()

signal Recruit_Character(Input_Stats : Player_Stats_Resource)

func _ready() -> void:
	print(SETUP_STATS.MAX_HEALTH)
	
	GENDER_TEXT.text = GENDER
	NAME_TEXT.text = (CODENAME)
	
	STRENGTH_TEXT.text = ("STRENGTH : " + str(STRENGTH))
	ENDURANCE_TEXT.text = ("ENDURANCE : " + str(ENDURANCE))
	DEXTERITY_TEXT.text = ("DEXTERITY : " + str(DEXTERITY))
	
	ROLE_TEXT.text = (ROLE)
	
	SETUP_STATS.CHARACTER_NAME = CODENAME
	SETUP_STATS.Player_Type = ROLE


func _on_button_pressed() -> void:
	emit_signal("Recruit_Character", SETUP_STATS)

extends Node2D
class_name  Randomized_Character_Card

var SETUP_STATS : Randomized_Player_Stats = Randomized_Player_Stats.new()
var RNG = RandomNumberGenerator.new()

@onready var NAME_TEXT : Label = %NAME_LABEL
var CODENAME = SETUP_STATS.CODENAME.pick_random()

@onready var GENDER_TEXT : Label = %GENDER_LABEL
var GENDER = SETUP_STATS.Gender.pick_random()

@onready var STRENGTH_TEXT : Label = %STRENGTH_LABEL
var STRENGTH = SETUP_STATS.STRENGTH
@onready var SPEED_TEXT : Label = %SPEED_LABEL
var SPEED = SETUP_STATS.SPEED
@onready var ENDURANCE_TEXT : Label = %ENDURANCE_LABEL
var ENDURANCE = SETUP_STATS.ENDURANCE
@onready var DEXTERITY_TEXT : Label = %DEXTERITY_LABEL
var DEXTERITY = SETUP_STATS.DEXTERITY

@onready var HP_TEXT : Label = %HP_LABEL
var HP = SETUP_STATS.MAX_HEALTH
@onready var STAMINA_TEXT : Label = %STAMINA_LABEL
var STAMINA = SETUP_STATS.MAX_STAMINA

func _ready() -> void:
	
	GENDER_TEXT.text = GENDER
	NAME_TEXT.text = (CODENAME)
	
	SPEED_TEXT.text = ("SPEED : " + str(SPEED))
	STRENGTH_TEXT.text = ("STRENGTH : " + str(STRENGTH))
	ENDURANCE_TEXT.text = ("ENDURANCE : " + str(ENDURANCE))
	DEXTERITY_TEXT.text = ("DEXTERITY : " + str(DEXTERITY))
	
	HP_TEXT.text = ("HP : " + str(HP))
	STAMINA_TEXT.text = ("STAMINA : " + str(STAMINA))

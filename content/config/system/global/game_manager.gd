extends Node

@export var MOUSE_SENSITIVTY : float = 0.5
var Global_Character : Player_Stats_Resource

var _Player : Player_Controller

@export var Primary_Weapon : String
@export var Secondary_Weapon : String
@export var Melee_Weapon : String


func Update_InGame_Character_Stats(SelectedCharacter : In_Game_PlayerStats):
	if Global_Character:
		SelectedCharacter.CODENAME = Global_Character.CHARACTER_NAME
		SelectedCharacter.Player_Type = Global_Character.Player_Type
		
		SelectedCharacter.ENDURANCE = Global_Character.ENDURANCE
		SelectedCharacter.DEXTERITY = Global_Character.DEXTERITY
		SelectedCharacter.LUCK = Global_Character.LUCK
		SelectedCharacter.MAX_STAMINA = Global_Character.MAX_STAMINA
		
		SelectedCharacter._set_up_character()


func Create_Global_Character_Stats(ReferenceCharacter : Player_Stats_Resource):
	Global_Character = Player_Stats_Resource.new()
	
	Global_Character.CHARACTER_NAME = ReferenceCharacter.CHARACTER_NAME
	Global_Character.Gender = ReferenceCharacter.Gender
	
	Global_Character.Player_Type = ReferenceCharacter.Player_Type
	Global_Character.ENDURANCE = ReferenceCharacter.ENDURANCE
	Global_Character.DEXTERITY = ReferenceCharacter.DEXTERITY
	Global_Character.LUCK = ReferenceCharacter.LUCK
	Global_Character.MAX_STAMINA = ReferenceCharacter.MAX_STAMINA

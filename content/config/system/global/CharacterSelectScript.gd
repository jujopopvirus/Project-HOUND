extends Node2D


func _on_character_01_recruit_character(Input_Stats: Player_Stats_Resource) -> void:
	GlobalGameManager.Create_Global_Character_Stats(Input_Stats)
	Proceed_To_Map()

func _on_character_02_recruit_character(Input_Stats: Player_Stats_Resource) -> void:
	GlobalGameManager.Create_Global_Character_Stats(Input_Stats)
	Proceed_To_Map()

func _on_character_03_recruit_character(Input_Stats: Player_Stats_Resource) -> void:
	GlobalGameManager.Create_Global_Character_Stats(Input_Stats)
	Proceed_To_Map()

func _on_character_04_recruit_character(Input_Stats: Player_Stats_Resource) -> void:
	GlobalGameManager.Create_Global_Character_Stats(Input_Stats)
	Proceed_To_Map()

func Proceed_To_Map():
	get_tree().change_scene_to_file("res://content/scenes/maps/h_circlemall.tscn")

@icon("res://content/ui/godot_icons/enemy_stats3.svg")

extends CharacterBody3D
class_name Enemy_Body

@export_category("Enemy Stats")
@export var Max_Health = 20.0
var Health = 20
@export var Defense = 0.0

@export var Damage = 20.0
@export var Shielded : bool = false

signal Enemy_Killed

func apply_damage(type : String, set_dmg : float) -> float:
	var calculated_damage
	
	match type:
		"Bullet":
			calculated_damage = (set_dmg)
		"Melee":
			calculated_damage = (set_dmg - Defense)
	
	print(calculated_damage)
	return calculated_damage

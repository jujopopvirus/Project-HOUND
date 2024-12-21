@icon("res://content/ui/godot_icons/gun_stats3.png")
class_name Gun_Resource

extends Node3D

@export_group("Animations_Name")
@export var Anim_Player : AnimationPlayer
@export var Activate_Animations : String
@export var Deactivate_Animations : String
@export var Attack_Animations : String

@export_group("Gun Stats")
@export var Melee_Weapon : bool = false

@export var Damage_Interval : int = 5
@export var Fire_Rate : int = 1

@export var Max_Ammo : int = 12
@onready var Current_Ammo = Max_Ammo

@onready var WPN_Manager : Weapon_Manager = get_parent()

func gun_fire():
	Anim_Player.play(Attack_Animations)
	return

func gun_deactivates():
	hide()
	Anim_Player.speed_scale = 1
	Anim_Player.play(Deactivate_Animations)
	await Anim_Player.animation_finished
	return

func gun_activates():
	show()
	Anim_Player.play(Activate_Animations)
	await Anim_Player.animation_finished
	Anim_Player.speed_scale = Fire_Rate
	return

func gun_special():
	return

func gun_ultimate():
	return

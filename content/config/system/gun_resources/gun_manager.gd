@icon("res://content/ui/godot_icons/gun_manager.png")
class_name Weapon_Manager

extends Node3D

var current_wpn : Gun_Resource

var number_of_wpn : int = 1

@export var Anim_Player : AnimationPlayer

@onready var Gun_Melee : Gun_Resource = %Knev
@onready var Gun_Primary : Gun_Resource = %Shelby
@onready var Gun_Secondary : Gun_Resource = %"AK-ira"

func _ready():
	switched_weapon(Gun_Primary)

func switched_weapon(weapon : Gun_Resource):
	
	if current_wpn != null:
		current_wpn.gun_deactivates()
	
	current_wpn = weapon
	current_wpn.gun_activates()

func _input(event):
	
	if event.is_action_pressed("gun_01"):
		switched_weapon(Gun_Primary)
	elif event.is_action_pressed("gun_02"):
		switched_weapon(Gun_Secondary)
	elif event.is_action_pressed("gun_03"):
		switched_weapon(Gun_Melee)
	
	if Input.is_action_pressed("w_shoot"):
		if not Anim_Player.is_playing():
			current_wpn.gun_fire()

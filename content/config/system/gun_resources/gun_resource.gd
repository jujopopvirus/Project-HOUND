@icon("res://content/ui/godot_icons/gun_stats3.png")
class_name Gun_Resource
extends Resource

enum GUNType {
	MELEE_WEAPON,
	HITSCAN_WEAPON,
	PROJECTILE_WEAPON,
	SHOTGUN_WEAPON,
	EMPTY
}

@export var Gun_Type : GUNType
@export var Gun_Name : String
@export var view_model : Mesh = null

@export_category("Gun_Stats")
@export var ammo : String 
@export var cooldown : float = 0.2
@export var sway : float = 0.10
@export var fire_rate : float = 2
@export var automatic : bool = false

@export_category("Bullet_Stats")
@export var projectile_scene : PackedScene 
@export var bullet_patterns : Curve2D
@export var bullet_damage : int = 15
@export var spread : float
@export var max_ammo : int = 12
var current_ammo : int = max_ammo
@export var bullet_amnt : int = 1
@export var bullet_range : int = 40


@export_category("Gun_Sounds")
@export var firing_sounds : Array[AudioStream]
@export var reload_sounds : AudioStream
@export var empty_gun_sounds : AudioStream

@export_category("Gun_Animations")
@export var idle_animation : String = "weapon_idle"
@export var shoot_animation : String = "gun_shoot"
@export var equip_animation : String = "weapon_deploy"
@export var reload_animation : String

var weapon_manager : Weapon_Manager

var trigger_down = false :
	set(v):
		if trigger_down != v:
			trigger_down = v
			if trigger_down:
				on_trigger_down()
			else:
				on_trigger_up()

var is_equipped := false :
	set(v):
		if is_equipped != v:
			is_equipped = v
			if is_equipped:
				on_equip()
			else:
				on_unequip()

func on_process(_delta):
	if trigger_down and automatic:
		if current_ammo > 0:
			activate_weapons()
		else:
			print("No Ammo")

func on_trigger_down():
	activate_weapons()

func on_trigger_up():
	pass

func on_equip():
	weapon_manager.play_animation(equip_animation, 1)
	print("equipped")

func on_unequip():
	trigger_down = false
	pass

func activate_weapons():
	weapon_manager.play_animation(shoot_animation, fire_rate)
	weapon_manager.weapon_shoot()

@icon("res://content/ui/godot_icons/gun_manager.png")
class_name Weapon_Manager
extends Node3D
#

@export var Player_Character : Player_Controller
@export var BulletCast : RayCast3D
@export var GunMesh : MeshInstance3D
@onready var WeaponSystem : WeaponSystem = %WeaponSystem

var Weapon_Slot : Array = [PUMPOFF, GLOCK, KNIFE, EMPTY]

var current_gun : Gun_Resource = Weapon_Slot[3]
var can_shoot : bool = true
var is_reloading : bool = false
var current_bullets : int = current_gun.current_ammo

const EMPTY = preload("res://content/config/system/gun_resources/Guns_Presets/BeginnerWeapons/empty.tres")
const GLOCK = preload("res://content/config/system/gun_resources/Guns_Presets/BeginnerWeapons/graylock.tres")
const KNIFE = preload("res://content/config/system/gun_resources/Guns_Presets/BeginnerWeapons/knife.tres")
const SL_GUN = preload("res://content/config/system/gun_resources/Guns_Presets/BeginnerWeapons/spitlizard.tres")
const PUMPOFF = preload("res://content/config/system/gun_resources/Guns_Presets/AdvancedWeapons/pumpoff.tres")

var ammo : Dictionary = {
	"MELEE" : 1,
	"PISTOL" : 200,
	"SHOTGUN" : 200,
	"SMG" : 200,
	"RIFLE" : 200,
	"EMPTY" : 0
}


func  _ready() -> void:
	update_mesh()

func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("w_shoot"):
		WeaponSystem.weapon_shoot()
	
	
	if event.is_action_pressed("gun_01"):
		_switch_weapons(0)
	elif event.is_action_pressed("gun_02"):
		_switch_weapons(1)
	elif event.is_action_pressed("gun_03"):
		_switch_weapons(2)
	elif event.is_action_pressed("gun_04"):
		_switch_weapons(3)

func _switch_weapons(weapon_switch : int) -> void:
	
	if current_gun != Weapon_Slot[weapon_switch]:
		
		if current_gun != null :
			current_gun = Weapon_Slot[weapon_switch]
		
			ammo[current_gun.ammo] += current_bullets
			current_bullets = 0
		
			
			
			update_mesh(current_gun.view_model)
			
			match ammo[current_gun.ammo] >= current_gun.max_ammo:
				true:
					current_bullets = current_gun.max_ammo
					ammo[current_gun.ammo] -= current_gun.max_ammo
				false:
					current_bullets += ammo[current_gun.ammo] 
					ammo[current_gun.ammo] = 0
			
		else:
			update_mesh()
		
		
		
	else:
		return

func update_mesh(mesh_replacement : Mesh = null) -> void:
	GunMesh.mesh = mesh_replacement

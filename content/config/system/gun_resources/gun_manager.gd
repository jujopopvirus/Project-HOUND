@icon("res://content/ui/godot_icons/gun_manager.png")
class_name Weapon_Manager
extends Node3D
#

@export var Player_Character : Player_Controller
@export var Raycast_Gun : RayCast3D
@export var GunMesh : MeshInstance3D

var Weapon_Slot : Array = [SL_GUN, GLOCK, KNIFE, EMPTY]

var current_gun : Gun_Resource = Weapon_Slot[3]
var can_shoot : bool = true
var is_reloading : bool = false
var current_bullets : int = current_gun.max_magazines

const EMPTY = preload("res://content/config/system/gun_resources/Guns_Presets/BeginnerWeapons/empty.tres")
const GLOCK = preload("res://content/config/system/gun_resources/Guns_Presets/BeginnerWeapons/graylock.tres")
const KNIFE = preload("res://content/config/system/gun_resources/Guns_Presets/BeginnerWeapons/knife.tres")
const SL_GUN = preload("res://content/config/system/gun_resources/Guns_Presets/BeginnerWeapons/spitlizard.tres")

func  _ready() -> void:
	update_mesh()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("gun_01"):
		_switch_weapons(0)
	elif event.is_action_pressed("gun_02"):
		_switch_weapons(1)
	elif event.is_action_pressed("gun_03"):
		_switch_weapons(2)
	elif event.is_action_pressed("gun_04"):
		_switch_weapons(3)

func _switch_weapons(weapon_switch : int) -> void:
	current_gun = Weapon_Slot[weapon_switch]
	current_bullets = current_gun.max_magazines
	if current_gun != null :
		print("Gun Name : " + current_gun.Gun_Name)
		print("Current Ammo : " + str(current_bullets))
		update_mesh(current_gun.view_model)
	else:
		update_mesh()
	

func update_mesh(mesh_replacement : Mesh = null) -> void:
	GunMesh.mesh = mesh_replacement

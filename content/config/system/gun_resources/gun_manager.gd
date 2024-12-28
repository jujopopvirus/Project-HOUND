@icon("res://content/ui/godot_icons/gun_manager.png")
class_name Weapon_Manager
extends Node3D
#

@export var Player_Character : Player_Controller

@export var allow_shoot : bool = true
@export var BulletCast : RayCast3D
@export var GunMesh : MeshInstance3D
@export var Bullet_Position : Marker3D

var Weapon_Slot : Array = [PUMPOFF, GLOCK, KNIFE, EMPTY]

var current_gun : Gun_Resource = Weapon_Slot[0]
var can_shoot : bool = true
var is_reloading : bool = false
var current_bullets : int = current_gun.current_ammo

var Debug_Bullets = preload("res://content/config/system/gun_resources/Guns_Presets/Decals/bullet_debug.tscn")

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
	_switch_weapons(3)

func _input(event: InputEvent) -> void:
	
	
	if event.is_action_pressed("gun_01"):
		_switch_weapons(0)
	elif event.is_action_pressed("gun_02"):
		_switch_weapons(1)
	elif event.is_action_pressed("gun_03"):
		_switch_weapons(2)
	elif event.is_action_pressed("gun_04"):
		_switch_weapons(3)

func _process(delta: float) -> void:
	if current_gun:
		current_gun.on_process(delta)

func _unhandled_input(event: InputEvent) -> void:
	
	if current_gun != null:
		if event.is_action_pressed("w_shoot") and allow_shoot:
			current_gun.trigger_down = true
		elif event.is_action_pressed("w_shoot") and allow_shoot and current_gun.automatic:
			current_gun.trigger_down = true
		elif event.is_action_released("w_shoot"):
			current_gun.trigger_down = false

func update_mesh(mesh_replacement : Mesh = null) -> void:
	GunMesh.mesh = mesh_replacement

func _switch_weapons(weapon_switch : int) -> void:
	
	current_gun = Weapon_Slot[weapon_switch]
	current_gun.weapon_manager = self
	
	if current_gun != null :
		current_gun.is_equipped = true
		current_gun.weapon_manager = self
		update_mesh(current_gun.view_model)
	else:
		update_mesh()
	

func weapon_shoot():
	
	
	var spread_x : float = randf_range(current_gun.spread * -1, current_gun.spread)
	var spread_y : float = randf_range(current_gun.spread * -1, current_gun.spread)
	
	BulletCast.target_position = Vector3(spread_x, spread_y, -current_gun.bullet_range)
	
	BulletCast.force_raycast_update()
	
	if BulletCast.is_colliding():
		var HitIndicator = Debug_Bullets.instantiate()
		var world = get_tree().get_root()
		world.add_child(HitIndicator)
		
		var Bullet_Coll = BulletCast.get_collision_point()
		
		HitIndicator.global_translate(Bullet_Coll)
		
		if BulletCast.get_collider().is_in_group("Enemy"):
			var collider : Enemy_Body = BulletCast.get_collider()
			collider.apply_damage("Bullet" ,current_gun.bullet_damage)
	else:
		print("missed")

@icon("res://content/ui/godot_icons/gun_manager.png")
class_name Weapon_Manager
extends Node3D
#
@export_category("Weapon Slots")
var Weapon_Slot : Array = [EMPTY, EMPTY, EMPTY, EMPTY]

@export_category("Processing")
@export var Player_Character : Player_Controller
@export var allow_shoot : bool = true
@export var BulletCast : RayCast3D
@export var GunMesh : MeshInstance3D
@export var Bullet_Position : Marker3D
@export var Bullet_LookAt : Marker3D

@onready var AnimPlayer : AnimationPlayer = %AnimationPlayer


var Collision_Exclusion = []

var current_gun : Gun_Resource = Weapon_Slot[0]
var can_shoot : bool = true
var is_reloading : bool = false
var current_bullets : int = current_gun.current_ammo

const EMPTY = preload("res://content/config/system/gun_resources/Guns_Presets/BeginnerWeapons/empty.tres")

enum {
	MELEE_WEAPON,
	HITSCAN_WEAPON,
	PROJECTILE_WEAPON,
	SHOTGUN_WEAPON
}

func  _ready() -> void:
	_give_player_a_weapon(GlobalGameManager.Primary_Weapon, GlobalGameManager.Secondary_Weapon, GlobalGameManager.Melee_Weapon)
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
		elif event.is_action_released("w_shoot"):
			current_gun.trigger_down = false
		elif event.is_action_pressed("w_reload"):
			current_gun.reload()

func _give_player_a_weapon(PrimaryWPN : String = "", SecondaryWPN : String = "", MeleeWPN : String = ""):
	
	if PrimaryWPN != "":
		Weapon_Slot[0] = get_weapon(PrimaryWPN)
	if SecondaryWPN != "":
		Weapon_Slot[1] = get_weapon(SecondaryWPN)
	if MeleeWPN != "":
		Weapon_Slot[2] = get_weapon(MeleeWPN)


func get_weapon(weapon_input : String) -> Gun_Resource:
	var ADDED_WEAPON : Gun_Resource
	
	match weapon_input:
		"KNIFE":
			ADDED_WEAPON = preload("res://content/config/system/gun_resources/Guns_Presets/MeleeWeapons/knife.tres")
		"SPIT_LIZARD":
			ADDED_WEAPON = preload("res://content/config/system/gun_resources/Guns_Presets/BeginnerWeapons/spit_lizard.tres")
		"PORCUPINE":
			ADDED_WEAPON = preload("res://content/config/system/gun_resources/Guns_Presets/BeginnerWeapons/porcupine.tres")
		"POCKETHERO":
			ADDED_WEAPON = preload("res://content/config/system/gun_resources/Guns_Presets/BeginnerWeapons/pocket_hero.tres")

		"GRAYLOCK":
			ADDED_WEAPON = preload("res://content/config/system/gun_resources/Guns_Presets/AdvancedWeapons/graylock.tres")
		"PUMPOFF":
			ADDED_WEAPON = preload("res://content/config/system/gun_resources/Guns_Presets/AdvancedWeapons/pumpoff.tres")

		_:
			ADDED_WEAPON = preload("res://content/config/system/gun_resources/Guns_Presets/BeginnerWeapons/empty.tres")
	return ADDED_WEAPON

#region Gun Process
func update_mesh(mesh_replacement : Mesh = null) -> void:
	GunMesh.mesh = mesh_replacement

func _switch_weapons(weapon_switch : int) -> void:
	
	current_gun = Weapon_Slot[weapon_switch]
	current_gun.weapon_manager = self
	current_gun.is_equipped = false
	
	if current_gun != null :
		current_gun.is_equipped = true
		current_gun.weapon_manager = self
		update_mesh(current_gun.view_model)
		
		BulletCast.target_position = Vector3(0, 0, -current_gun.bullet_range)
		BulletCast.force_raycast_update()
	else:
		update_mesh()

func weapon_shoot():
	
	if current_gun.Gun_Name != "Empty":
		match current_gun.Gun_Type:
			HITSCAN_WEAPON:
				Hitscan_Weapon()
			PROJECTILE_WEAPON:
				Projectile_Weapon()
			SHOTGUN_WEAPON:
				Shotgun_Weapon()
			MELEE_WEAPON:
				Hitscan_Weapon()

func Projectile_Weapon() -> void:
	
	var Projectile : Projectile_Bullet = current_gun.projectile_scene.instantiate()
	var Projectile_RID = Projectile.get_rid()
	var Dir : Vector3
	
	var spread_x : float = randf_range(current_gun.spread * -1, current_gun.spread)
	var spread_y : float = randf_range(current_gun.spread * -1, current_gun.spread)
	BulletCast.target_position = Vector3(spread_x, spread_y, -current_gun.bullet_range)
	BulletCast.force_raycast_update()
	
	if BulletCast.is_colliding():
		var RayPoint = BulletCast.get_collision_point()
		Dir = (RayPoint - Bullet_Position.get_global_transform().origin).normalized()
	else:
		Dir = (Bullet_LookAt.get_global_transform().origin - Bullet_Position.get_global_transform().origin).normalized()
	
	Bullet_Position.add_child(Projectile)
	
	Collision_Exclusion.push_front(Projectile_RID)
	Projectile.tree_exited.connect(Remove_Exclusion.bind(Projectile.get_rid()))
	
	Projectile.global_transform = Bullet_Position.global_transform
	Projectile.set_as_top_level(true)
	Projectile.look_at(Bullet_LookAt.get_global_transform().origin)
	Projectile.damage = current_gun.bullet_damage
	Projectile.set_linear_velocity(Dir * 140)

func Shotgun_Weapon() -> void:
	var SprayVector = current_gun.bullet_patterns
	randomize()
	
	for point in SprayVector.get_point_count():
		var Spraypoint : Vector2 = SprayVector.get_point_position(point)
		var Randomize = current_gun.spread
		
		Spraypoint.x = (Spraypoint.x * randf_range(-Randomize, Randomize)) -10
		Spraypoint.y = (Spraypoint.y * randf_range(-Randomize, Randomize)) +5
		
		Launch_Shotgun_Bullets(Spraypoint)

func Launch_Shotgun_Bullets(get_point : Vector2):
	var Projectile : Projectile_Bullet = current_gun.projectile_scene.instantiate()
	var Projectile_RID = Projectile.get_rid()
	
	var _point : Vector3 = Vector3(get_point.x, get_point.y, -10)
	_point = Bullet_LookAt.global_transform * _point
	
	add_child(Projectile)
	
	Collision_Exclusion.push_front(Projectile_RID)
	Projectile.tree_exited.connect(Remove_Exclusion.bind(Projectile.get_rid()))
	
	var Dir = (_point - global_transform.origin).normalized()
	
	Projectile.global_transform = Bullet_Position.global_transform
	Projectile.set_as_top_level(true)
	Projectile.look_at(_point)
	Projectile.damage = current_gun.bullet_damage
	Projectile.set_linear_velocity(Dir * 140)

func Recover_Ammo():
	current_gun.current_ammo = current_gun.max_ammo

func Remove_Exclusion(Projectile_Rid):
	Collision_Exclusion.erase(Projectile_Rid)

func Hitscan_Weapon() -> void:
	var spread_x : float = randf_range(current_gun.spread * -1, current_gun.spread)
	var spread_y : float = randf_range(current_gun.spread * -1, current_gun.spread)
	
	BulletCast.target_position = Vector3(spread_x, spread_y, -current_gun.bullet_range)
	
	BulletCast.force_raycast_update()

#endregion

func play_animation(input_anim : String, speed_scale : float):
	if current_gun:
		AnimPlayer.speed_scale = speed_scale
		AnimPlayer.play(input_anim)

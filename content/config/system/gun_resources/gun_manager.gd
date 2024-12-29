@icon("res://content/ui/godot_icons/gun_manager.png")
class_name Weapon_Manager
extends Node3D
#

@export var Player_Character : Player_Controller

@export var allow_shoot : bool = true
@export var BulletCast : RayCast3D
@export var GunMesh : MeshInstance3D
@export var Bullet_Position : Marker3D
@export var Bullet_LookAt : Marker3D

@onready var AnimPlayer : AnimationPlayer = %AnimationPlayer
var Weapon_Slot : Array = [EAGLEEYE, GLOCK, PUMPOFF, EMPTY]

var Collision_Exclusion = []

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
const NB_RIFLE = preload("res://content/config/system/gun_resources/Guns_Presets/AdvancedWeapons/natureboy.tres")
const OUTRUNNER = preload("res://content/config/system/gun_resources/Guns_Presets/AdvancedWeapons/outrunner.tres")
const EAGLEEYE = preload("res://content/config/system/gun_resources/Guns_Presets/AdvancedWeapons/EagleEye.tres")

enum {
	MELEE_WEAPON,
	HITSCAN_WEAPON,
	PROJECTILE_WEAPON,
	SHOTGUN_WEAPON
}

var ammo : Dictionary = {
	"MELEE" : 1,
	"PISTOL" : 200,
	"SHOTGUN" : 200,
	"SMG" : 200,
	"RIFLE" : 200,
	"EMPTY" : 0
}


func  _ready() -> void:
	_switch_weapons(1)

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
	else:
		update_mesh()


func weapon_shoot():
	
	match current_gun.Gun_Type:
		HITSCAN_WEAPON:
			Hitscan_Weapon()
		PROJECTILE_WEAPON:
			Projectile_Weapon()
		SHOTGUN_WEAPON:
			Shotgun_Weapon()
		MELEE_WEAPON:
			Hitscan_Weapon()
	
	
	#if current_gun.projectile_bullets:
		#Projectile_Weapon()
	#else:
		#Hitscan_Weapon()
	



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
	


func Remove_Exclusion(Projectile_Rid):
	Collision_Exclusion.erase(Projectile_Rid)

func Hitscan_Weapon() -> void:
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

func play_animation(input_anim : String, speed_scale : float):
	if current_gun:
		AnimPlayer.speed_scale = speed_scale
		AnimPlayer.play(input_anim)

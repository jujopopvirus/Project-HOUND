@icon("res://content/ui/godot_icons/gun_stats3.png")
class_name Gun_Resource
extends Resource

enum GUNType {
	MELEE,
	REVOLVER,
	RIFLE,
	SHOTGUN,
	EMPTY
}

@export var Gun_Type : GUNType
@export var Gun_Name : String
@export var view_model : Mesh = null

@export_category("Gun_Stats")
@export var ammo : String 
@export var cooldown : float = 0.2
@export var sway : float = 0.10
@export var automatic : bool = false

@export_category("Bullet_Stats")
@export var bullet_damage : int = 15
@export var spread : float
@export var max_magazines : int
@export var bullet_amnt : int = 1
@export var bullet_range : int = 40

@export_category("Gun_Sounds")
@export var firing_sounds : Array[AudioStream]
@export var reload_sounds : AudioStream
@export var empty_gun_sounds : AudioStream

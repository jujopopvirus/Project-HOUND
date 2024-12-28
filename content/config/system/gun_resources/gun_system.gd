extends Node
class_name WeaponSystem

@export var parent : Weapon_Manager
@export var CharacterStats : Character_Stats
@onready var cooldown_time : Timer = %CooldownTimer

var current_gun : Gun_Resource

func weapon_shoot():
	print("pew")

func _on_cooldown_timer_timeout() -> void:
	parent.can_shoot = true

extends Node
class_name WeaponSystem

@export var parent : Weapon_Manager
@export var CharacterStats : Character_Stats
@onready var cooldown_time : Timer = %CooldownTimer

var current_gun : Gun_Resource

func weapon_shoot():
	current_gun = parent.current_gun
	
	if parent.can_shoot and parent.current_bullets > 0:
		var valid_bullets : Array[Dictionary] = get_bullet_raycast()
		
		if current_gun.Gun_Type != Gun_Resource.GUNType.MELEE ||  current_gun.Gun_Type != Gun_Resource.GUNType.EMPTY:
			parent.current_bullets -= 1
			
			parent.can_shoot = false
			cooldown_time.start(current_gun.cooldown)
			
			if not valid_bullets.is_empty():
				for bullets in valid_bullets:
					
					if bullets.hit_target.is_in_group("Enemy"):
						bullets.hit_target._get_damage(get_bullet_damage() * -1)
	
	
	print(parent.current_bullets)

func get_bullet_damage() -> int:
	var overall_damage = current_gun.bullet_damage
	
	return overall_damage


func get_bullet_raycast():
	current_gun = parent.current_gun
	
	var bullet_cast = parent.BulletCast
	var valid_bullets : Array[Dictionary]
	
	for b in current_gun.bullet_amnt:
		
		var spread_x : float = randf_range(current_gun.spread * -1, current_gun.spread)
		var spread_y : float = randf_range(current_gun.spread * -1, current_gun.spread)
		
		bullet_cast.target_position = Vector3(spread_x, spread_y, -current_gun.bullet_range)
		
		bullet_cast.force_raycast_update()
		var hit_target = bullet_cast.get_collider()
		var coll_point = bullet_cast.get_collision_point()
		var coll_normal = bullet_cast.get_collision_normal()
		
		if hit_target != null:
			var valid_bullet : Dictionary = {
				"hit_target" : hit_target, 
				"coll_point" : coll_point,
				"coll_normal" : coll_normal
			}
			
			valid_bullets.append(valid_bullet)
	
	
	return valid_bullets

func _on_cooldown_timer_timeout() -> void:
	parent.can_shoot = true

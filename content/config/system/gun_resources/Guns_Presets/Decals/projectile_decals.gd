extends RigidBody3D
class_name Projectile_Bullet

var Debug_Bullets = preload("res://content/config/system/gun_resources/Guns_Presets/Decals/bullet_debug.tscn")
var damage : int = 70

func _on_timer_timeout() -> void:
	queue_free()

func _on_area_3d_body_entered(body: Node3D) -> void:
	var HitIndicator = Debug_Bullets.instantiate()
	var world = get_tree().get_root()
	world.add_child(HitIndicator)
	
	HitIndicator.position = global_position
	
	if body.is_in_group("Enemy"):
		body.apply_damage("Bullet" ,damage)
		queue_free()
	queue_free()

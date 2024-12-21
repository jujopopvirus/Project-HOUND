extends Gun_Resource



func _on_a_kira_hitbox_body_entered(body):
	print(body.apply_damage("Bullet", Damage_Interval))

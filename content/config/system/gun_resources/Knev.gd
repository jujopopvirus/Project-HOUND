extends Gun_Resource


func _on_knev_hitbox_body_entered(body : Enemy_Body):
	print(body.apply_damage("Melee", Damage_Interval))

extends Gun_Resource

signal shotgun_blast

func gun_fire():
	Anim_Player.play(Attack_Animations)
	emit_signal("shotgun_blast")
	await Anim_Player.animation_finished
	return

func _on_shelby_hitbox_body_entered(body):
	print(body.apply_damage("Bullet", Damage_Interval))

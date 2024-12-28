extends Sprite3D
class_name Bullet_Decals


func _on_timer_timeout() -> void:
	queue_free()

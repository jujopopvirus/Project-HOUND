extends Area3D
class_name Boost_Area


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		body.player_jump(20)

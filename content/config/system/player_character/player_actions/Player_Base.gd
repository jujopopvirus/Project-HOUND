extends Character_Actions

var SPEED : float

@onready var RUN_SPD = Stats.SPRINT_speed
@onready var WALK_SPD = Stats.WALKING_speed
@onready var JUMP_VELOCITY = Stats.JUMP_strength
var wish_dir = Vector3.ZERO


@export var camera : Node3D

var velocity_direction = Vector3()
@export var velocity_speed = 120
var velocity_time = 0.5

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * 2


func enter_actions():
	set_physics_process(true)
#
func exit_actions():
	set_physics_process(false)

func get_movement_speed() -> float:
	return RUN_SPD if Input.is_action_pressed("m_sprint") else WALK_SPD

func actions_input_process(delta : float):
	
	pass

func handle_gravity(get_velocity : Vector3, delta : float) -> void:
	get_velocity.y -= gravity * delta

func handle_ground_movement(get_velocity : Vector3, wish_direction : Vector3) -> void:
	get_velocity.x = wish_direction.x * get_movement_speed()
	get_velocity.z = wish_direction.z * get_movement_speed()


func movement_input_process(delta : float) -> Vector3:
	var input_dir = Input.get_vector("m_left", "m_right", "m_forward", "m_backward").normalized()
	wish_dir = Player.global_transform.basis * Vector3(-input_dir.x, 0.0, -input_dir.y)
	
	var new_velocity = Player.velocity
	var Player_On_Floor = Player.is_on_floor()
	
	if Player.is_on_floor():
		handle_ground_movement(new_velocity, wish_dir)
	else:
		handle_gravity(new_velocity, delta)


	return new_velocity

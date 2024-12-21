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

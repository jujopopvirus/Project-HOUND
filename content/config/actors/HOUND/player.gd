@icon("res://content/ui/godot_icons/character_stats.svg")
class_name Player_Controller

extends CharacterBody3D

#region Reference Variables
@export var Char_Stats : Character_Stats
var SPEED : float


var autobhopping : bool = true
@onready var RUN_SPD = Char_Stats.SPRINT_speed
@onready var WALK_SPD = Char_Stats.WALKING_speed
@onready var JUMP_VELOCITY = Char_Stats.JUMP_strength
var wish_dir = Vector3.ZERO

@export_group("Movement Settings")
@export_subgroup("Ground Movements")
@export var ground_deccel := 10.05
@export var ground_accel := 14.0
@export var ground_friction := 4

@export_subgroup("Air Movements")
@export var air_cap := 0.85
@export var air_accel := 860.0
@export var air_move_speed := 560


var _mouse_input : bool = false
var _mouse_rotation : Vector3

var _player_rotation : Vector3
var _camera_rotation : Vector3

var _rotation_input : float

@onready var MOUSE_SENSITIVITY = Char_Stats.MOUSE_SENSITIVITY
var _tilt_input : float
var tilt_limit := deg_to_rad(85.0)
@export var CAM_CONTROLLER : Camera3D

@onready var stair_lower : RayCast3D = %lowercast
@onready var stair_upper : RayCast3D = %uppercast
const MAX_STEP_HEIGHT = 0.5
var _snapped_to_stairs_frame := false
var _last_frame_was_on_floor = -INF


# Get the gravity from the project settings to be synced with RigidBody nodes.

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
#endregion



func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	

func _unhandled_input(event):
	_mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	if _mouse_input:
		_rotation_input = -event.relative.x
		_tilt_input = -event.relative.y

func update_cam(delta):
	_mouse_rotation.x += (_tilt_input * MOUSE_SENSITIVITY * 0.25) *  delta
	_mouse_rotation.x = clamp(_mouse_rotation.x, -tilt_limit, tilt_limit)
	_mouse_rotation.y += (_rotation_input * MOUSE_SENSITIVITY * 0.25) * delta
	
	_player_rotation = Vector3(0.0, _mouse_rotation.y, 0.0)
	_camera_rotation = Vector3(_mouse_rotation.x, 0.0 , 0.0)
	
	CAM_CONTROLLER.transform.basis = Basis.from_euler(_camera_rotation)
	CAM_CONTROLLER.rotation.z = 0.0
	
	global_transform.basis = Basis.from_euler(_player_rotation)
	
	_rotation_input = 0.0
	_tilt_input = 0.0

#---------------------------------------------------------------------------------------
#region Character_Movements

func is_surface_too_steep(normal :  Vector3) -> bool:
	return normal.angle_to(Vector3.UP) > self.floor_max_angle

func _run_body_test_motion(from : Transform3D, motion : Vector3, result = null) -> bool:
	if not result : result = PhysicsTestMotionResult3D.new()
	var params = PhysicsTestMotionParameters3D.new()
	params.from = from
	params.motion = motion
	return PhysicsServer3D.body_test_motion(self.get_rid(), params, result)

func _snap_down_to_stairs() -> void:
	var did_snap := false
	var floor_below : bool = stair_lower.is_colliding() and not is_surface_too_steep(stair_lower.get_collision_normal())
	var was_on_floor_last_frame = Engine.get_physics_frames() - _last_frame_was_on_floor == 1
	if not is_on_floor() and velocity.y <= 0 and (was_on_floor_last_frame or _snapped_to_stairs_frame) and floor_below:
		var body_test_result = PhysicsTestMotionResult3D.new()
		
		if _run_body_test_motion(self.global_transform, Vector3(0, -MAX_STEP_HEIGHT, 0), body_test_result):
			var translate_y = body_test_result.get_travel().y
			self.position.y += translate_y
			apply_floor_snap()
			did_snap = true
	_snapped_to_stairs_frame = did_snap

func _snap_up_to_stairs(delta) -> bool:
	if not is_on_floor() and not _snapped_to_stairs_frame : return false
	
	if self.velocity.y > 0 or (self.velocity * Vector3(1,0,1)).length() == 0: return false
	var expected_motion = self.velocity * Vector3(1,0,1) * delta
	var step_pos_with_clearance = self.global_transform.translated(expected_motion + Vector3(0, MAX_STEP_HEIGHT * 2, 0))
	
	var down_check = PhysicsTestMotionResult3D.new()
	if (_run_body_test_motion(step_pos_with_clearance, Vector3(0, -MAX_STEP_HEIGHT * 2, 0), down_check)
	and (down_check.get_collider().is_class("StaticBody3D") or down_check.get_collider().is_class("CSGShape3D"))):
		var step_height = ((step_pos_with_clearance.origin + down_check.get_travel()) - self.global_position).y
		
		if step_height > MAX_STEP_HEIGHT or step_height <= 0.01 or (down_check.get_collision_point() - self.global_position).y > MAX_STEP_HEIGHT : return false
		stair_upper.global_position = down_check.get_collision_point() + Vector3(0, MAX_STEP_HEIGHT, 0) + expected_motion.normalized() * 0.1
		stair_upper.force_raycast_update()
		if stair_upper.is_colliding() and not is_surface_too_steep(stair_upper.get_collision_normal()):
			self.global_position = step_pos_with_clearance.origin + down_check.get_travel()
			apply_floor_snap()
			_snapped_to_stairs_frame = true
			return true
	return false

func get_movement_speed() -> float:
	return RUN_SPD if Input.is_action_pressed("m_sprint") else WALK_SPD

func clip_velocity(normal:Vector3, overbounce : float, delta : float) -> void:
	var backoff := self.velocity.dot(normal) * overbounce
	
	if backoff >= 0:
		return
	
	var change := normal * backoff
	velocity -= change
	var adjust := self.velocity.dot(normal)
	
	if adjust < 0.0:
		self.velocity -= normal * adjust

func handle_gravity(delta : float) -> void:
	velocity.y -= gravity * delta
	
	var cur_speed_in_wish_dir = self.velocity.dot(wish_dir)
	var capped_speed = min((air_move_speed * wish_dir).length(),air_cap)
	var add_speed_till_cap = capped_speed - cur_speed_in_wish_dir
	
	if add_speed_till_cap > 0:
		var accel_speed = air_accel * air_move_speed * delta
		accel_speed = min(accel_speed, add_speed_till_cap)
		self.velocity += accel_speed * wish_dir
	
	if is_on_wall():
		
		if is_surface_too_steep(get_wall_normal()):
			self.motion_mode = CharacterBody3D.MOTION_MODE_FLOATING
		else:
			self.motion_mode = CharacterBody3D.MOTION_MODE_GROUNDED
		
		clip_velocity(get_wall_normal(), 1, delta)

func handle_ground_movement(delta : float) -> void:
	velocity.x = wish_dir.x * get_movement_speed()
	velocity.z = wish_dir.z * get_movement_speed()
	
	var cur_speed_in_wish_dir = self.velocity.dot(wish_dir)
	var add_speed_till_cap = get_movement_speed() - cur_speed_in_wish_dir
	
	if add_speed_till_cap >0:
		var accel_speed = ground_accel * delta * get_movement_speed()
		accel_speed = min(accel_speed, add_speed_till_cap)
		self.velocity += accel_speed * wish_dir

func _physics_process(delta):
	if is_on_floor(): _last_frame_was_on_floor = Engine.get_physics_frames()
	
	var input_dir = Input.get_vector("m_left", "m_right", "m_forward", "m_backward").normalized()
	wish_dir = self.global_transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)
	var Player_On_Floor = is_on_floor()
	
	
	if is_on_floor() or _snapped_to_stairs_frame:
		if Input.is_action_just_pressed("m_jump") or (autobhopping and Input.is_action_pressed("m_jump")):
			var jump_boost = get_movement_speed() / 6
			jump_boost = JUMP_VELOCITY + jump_boost
			player_jump(jump_boost)
		handle_ground_movement(delta)
	else:
		handle_gravity(delta)
	
	if not _snap_up_to_stairs(delta):
		
		Char_Stats.actions_process(delta)
		
		move_and_slide()
		_snap_down_to_stairs()
	
	update_cam(delta)


#endregion


#---------------------
#Player Commands
func player_jump(Jump_Strength : float) -> void:
	if velocity.y >= 0 :
		self.velocity.y += Jump_Strength

extends CharacterBody2D

####################################################################
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_buffer_timer: Timer = $JumpBufferTimer

var coyote_time_activated: bool = false

var MAX_JUMP_HEIGHT: float = -350.0
var gravity: float = 12.0
const MAX_GRAVITY: float = 14.5
const FALL_GRAVITY: float = 20

var MAX_SPEED: float = 50
const R_SPEED: float = 150
var ACCELERATION: float = 8
const FRICTION: float = 15

################################################
#MovemenPhysics process
func _physics_process(delta: float) -> void:
	#left and right movement
	var x_input: float = Input.get_action_strength("move right") - Input.get_action_strength("move left")
	var velocity_weight: float = delta * (ACCELERATION if x_input else FRICTION)
	velocity.x = lerp(velocity.x, x_input * MAX_SPEED, velocity_weight)

	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = MAX_JUMP_HEIGHT / 4

	#CoyoteTime and gravity
	if is_on_floor():
		coyote_time_activated = false
		gravity = lerp(gravity, 12.0, 12.0 * delta)
	else:
		if coyote_timer.is_stopped and !coyote_time_activated:
			coyote_timer.start()
			coyote_time_activated = true

		if Input.is_action_just_pressed("jump") or is_on_ceiling():
			velocity.y *= 0.5

		gravity = lerp(gravity, MAX_GRAVITY, 12.0 * delta)

	#Jump Buffer
	if Input.is_action_just_pressed("jump"):
		if jump_buffer_timer.is_stopped():
			jump_buffer_timer.start()

	if !jump_buffer_timer.is_stopped() and (!coyote_timer.is_stopped() or is_on_floor()):
		velocity.y = MAX_JUMP_HEIGHT
		jump_buffer_timer.stop()
		coyote_timer.stop()
		coyote_time_activated = true

	velocity.y += gravity

	move_and_slide()

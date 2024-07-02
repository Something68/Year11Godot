extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D

@export var speed = 300.0
@export var jump_velocity = -400.0
@export var acceleration : float = 15.0
@export var jump = 1
@onready var animator = $AnimationPlayer
var direction = Vector2.ZERO
enum state {Idle, Run, Death, Attack}
var anim_state = state.Idle
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func update_state():
	if anim_state == state.Death:
		return
	if is_on_floor():
		if velocity == Vector2.ZERO:
			anim_state = state.Idle
		elif velocity.x != 0:
			anim_state = state.Run

func update_animation(direction):
	pass
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		move_toward(velocity.x,direction*speed,acceleration)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = move_toward(velocity.x, speed,direction * acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	update_state()
	move_and_slide()

extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -130.0

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var jumpSound: AudioStreamPlayer2D = $jumpSound
var animation_locked : bool = false
var direction : Vector2 = Vector2.ZERO
var was_in_air : bool = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		was_in_air = true
	else:
		animation_locked = false
		was_in_air = false

	direction = Input.get_vector("left","right","up","down")
	# Handle jump.
	# if is_on_floor():
	#	velocity.y = JUMP_VELOCITY
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jump()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.

	if direction:
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		

	move_and_slide()
	update_animation()
	update_facing_direction()

func update_animation():
	if not animation_locked:
		if direction.x != 0:
			animated_sprite.play("run")
		else:
			animated_sprite.play("idle")
			
			
func update_facing_direction():
	if direction.x > 0:
		animated_sprite.flip_h = false
	elif direction.x < 0:
		animated_sprite.flip_h = true
		
func jump():
	velocity.y = JUMP_VELOCITY
	if jumpSound:
		jumpSound.play() 
	animated_sprite.play("jump")
	animation_locked = true

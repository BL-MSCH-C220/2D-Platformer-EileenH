extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -630.0
var can_double_jump = true 

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	if is_on_floor():
		can_double_jump = true
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		$Sprite.play("Fall")
	elif abs(velocity.x) > 0:
		$Sprite.play("Walk")
	else:
		$Sprite.play("Idle")

	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and (is_on_floor() or can_double_jump):
		if not is_on_floor():
			can_double_jump = false
		$Sprite.play("Jump")
		velocity.y = JUMP_VELOCITY
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
		if direction < 0:
			$Sprite.flip_h = true
		else:
			$Sprite.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	

	move_and_slide()


func _on_coin_collector_body_entered(body):
	if body.name == "Coins":
		body.get_coin(global_position)

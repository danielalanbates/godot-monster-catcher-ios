extends CharacterBody2D
## Simple 4-direction top-down movement controller. Original code.
##
## Reads from the standard ui_up/ui_down/ui_left/ui_right input actions so
## keyboard/arrow-key input works out of the box. The `move_direction`
## property can also be set directly (e.g. from a future on-screen virtual
## joystick or touch drag handler) to drive movement without a keyboard,
## which is why input reading and movement application are kept separate.

const SPEED := 120.0

## External input sources (touch, virtual joystick) can set this each frame
## instead of relying on Input.get_vector below.
var move_direction: Vector2 = Vector2.ZERO
var use_keyboard_input: bool = true

func _physics_process(_delta: float) -> void:
	if use_keyboard_input:
		move_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	velocity = move_direction * SPEED
	move_and_slide()

	if move_direction.length() > 0.01:
		_face_direction(move_direction)

func _face_direction(direction: Vector2) -> void:
	# Placeholder for 4-direction sprite facing; hook up AnimatedSprite2D
	# animation names ("walk_up", "walk_down", "walk_left", "walk_right")
	# here once real character sprites/animations are added.
	pass

## Called by a future touch/virtual-joystick input handler.
func set_touch_direction(direction: Vector2) -> void:
	use_keyboard_input = false
	move_direction = direction

extends Node
class_name PlayerMovementController

signal notify_move(is_move: bool)

@onready var player: Player = owner

var is_moving: bool = false



func _physics_process(delta):
	# Handle vertical velocity
	if !player.is_on_floor(): player.velocity.y -= player.fall_speed * delta
	else: player.velocity.y = 0

	# Get input direction
	var input_vector := Input.get_vector(Constants.InputNames.Left, Constants.InputNames.Right, Constants.InputNames.Forward, Constants.InputNames.Backward)
	var direction := player.transform.basis * Vector3(input_vector.x, 0, input_vector.y)

	# Move player
	if direction:
		player.velocity.x = direction.x * player.move_speed
		player.velocity.z = direction.z * player.move_speed
		if !is_moving:
			notify_move.emit(true)
			is_moving = true
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.move_speed / 2)
		player.velocity.z = move_toward(player.velocity.z, 0, player.move_speed / 2)
		if is_moving:
			notify_move.emit(false)
			is_moving = false
	player.move_and_slide()

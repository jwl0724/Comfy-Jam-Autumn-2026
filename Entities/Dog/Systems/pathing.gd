extends Node
class_name DogPathing

@export var follow_threshold: Area3D = null

@onready var dog: Dog = owner
@onready var pathing_target: Node3D = dog.player_node

var do_pathing: bool = true
var pathing_enabled: bool = true



func enable_pathing(enable: bool):
    pathing_enabled = enable


# TODO: Might need to switch to PathAgent3D later after the map is created, will need to see later
func _ready():
    follow_threshold.body_entered.connect(_on_body_entered)
    follow_threshold.body_exited.connect(_on_body_exited)



func _physics_process(delta):
    # Handle vertical velocity
    if !dog.is_on_floor(): dog.velocity.y -= dog.fall_speed * delta
    else: dog.velocity.y = 0

    if !pathing_target || !pathing_enabled:
        dog.move_and_slide()
        return

    # TODO: Refine behavior to be more dynamic, for now just do some very simple rudimentary following logic
    if !do_pathing:
        dog.velocity.x = move_toward(dog.velocity.x, 0, dog.move_speed / 4)
        dog.velocity.z = move_toward(dog.velocity.z, 0, dog.move_speed / 4)
    else:
        # Handle dog looking direction
        var old_rotation := dog.rotation
        dog.look_at(pathing_target.position)
        dog.rotation.x = 0
        var target_rotation := dog.rotation
        dog.rotation = old_rotation.lerp(target_rotation, dog.turn_rate)

        # Handle pathing direction
        var y_velocity = dog.velocity.y
        var dir_to_target := dog.position.direction_to(pathing_target.position)
        dir_to_target.y = y_velocity
        dog.velocity = dir_to_target * dog.move_speed
    dog.move_and_slide()




func _on_body_entered(body: Node3D):
    if body is not Player: return
    do_pathing = false



func _on_body_exited(body: Node3D):
    if body is not Player: return
    do_pathing = true
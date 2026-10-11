extends Node
class_name DogPathing

@export var follow_threshold: Area3D = null
@export var nav_agent: NavigationAgent3D = null

@onready var dog: Dog = owner
@onready var pathing_target: Node3D = dog.player_node

var do_pathing: bool = true
var pathing_enabled: bool = true



func enable_pathing(enable: bool):
    pathing_enabled = enable



func _ready():
    follow_threshold.body_entered.connect(_on_body_entered)
    follow_threshold.body_exited.connect(_on_body_exited)



func _physics_process(delta):
    # Handle vertical velocity
    if !dog.is_on_floor(): dog.velocity.y -= dog.fall_speed * delta
    else: dog.velocity.y = 0

    if Engine.get_physics_frames() % 10 == 0: nav_agent.target_position = pathing_target.global_position

    if !pathing_target || !pathing_enabled:
        dog.move_and_slide()
        return

    # TODO: Refine behavior to be more dynamic, for now just do some very simple rudimentary following logic
    if !do_pathing:
        dog.velocity.x = move_toward(dog.velocity.x, 0, dog.move_speed / 4)
        dog.velocity.z = move_toward(dog.velocity.z, 0, dog.move_speed / 4)
    else:
        if nav_agent.is_navigation_finished(): return

        # Handle pathing direction
        var next_pos = nav_agent.get_next_path_position()
        var direction = (next_pos - dog.global_position).normalized()
        dog.velocity.x = direction.x * dog.move_speed
        dog.velocity.z = direction.z * dog.move_speed

        # Handle dog looking position
        var old_rotation = dog.rotation
        dog.look_at(next_pos)
        var new_rotation = dog.rotation
        dog.rotation = old_rotation.lerp(new_rotation, dog.turn_rate)
        dog.rotation.x = 0
    dog.move_and_slide()




func _on_body_entered(body: Node3D):
    if body is not Player: return
    do_pathing = false



func _on_body_exited(body: Node3D):
    if body is not Player: return
    do_pathing = true
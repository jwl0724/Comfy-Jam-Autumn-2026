extends Node
class_name DogPathing

@export var follow_threshold: Area3D = null
@export var nav_agent: NavigationAgent3D = null

@onready var dog: Dog = owner
@onready var pathing_target: Node3D = dog.player_node

var do_pathing: bool = true
var pathing_enabled: bool = true

const frames_per_idle: int = 210
const wander_offset_max: int = 4
var idle_tween: Tween = null



func enable_pathing(enable: bool):
    pathing_enabled = enable



func _ready():
    follow_threshold.body_entered.connect(_on_body_entered)
    follow_threshold.body_exited.connect(_on_body_exited)



func _physics_process(delta):
    # Handle vertical velocity
    if !dog.is_on_floor(): dog.velocity.y -= dog.fall_speed * delta
    else: dog.velocity.y = 0

    # Handle if inactive
    if !dog.is_active:
        dog.velocity.x = 0
        dog.velocity.z = 0
        dog.move_and_slide()
        return

    # Handle disabled pathing behavior
    if !pathing_target || !pathing_enabled:
        dog.move_and_slide()

    # Handle idle behavior
    elif !do_pathing:
        # Handle wander navigation
        if !nav_agent.is_navigation_finished(): _set_next_navigation_properties()

        # Remove velocity when dog is NOT wandering
        else:
            dog.velocity.x = 0
            dog.velocity.z = 0
        dog.move_and_slide()

        # Queue up next action on downtime
        if (idle_tween && idle_tween.is_running()) || Engine.get_physics_frames() % frames_per_idle != 0: return

        var behavior = randi() % 4
        if behavior == 0: # Turn to player
            idle_tween = create_tween()
            idle_tween.tween_property(dog, "rotation", NodeUtils.get_look_at_position_rotation(dog, pathing_target.global_position), 0.5)
            idle_tween.play()

        elif behavior == 1: # Turn to random
            idle_tween = create_tween()
            idle_tween.tween_property(dog, "rotation", NodeUtils.get_look_at_position_rotation(dog, _get_random_nearby_position()), 0.5)
            idle_tween.play()

        else: nav_agent.target_position = _get_random_nearby_position() # Wander having higher chance

    # Handle pathing logic
    else:
        if nav_agent.is_navigation_finished(): return
        if idle_tween && idle_tween.is_running(): idle_tween.kill()
        if Engine.get_physics_frames() % 20 == 0 && do_pathing: nav_agent.target_position = pathing_target.global_position
        _set_next_navigation_properties()
        dog.move_and_slide()



func _set_next_navigation_properties():
    # Handle pathing direction
    var next_pos = nav_agent.get_next_path_position()
    var direction = (next_pos - dog.global_position).normalized()
    dog.velocity.x = direction.x * dog.move_speed
    dog.velocity.z = direction.z * dog.move_speed

    # Handle dog looking position
    if dog.global_position.distance_squared_to(next_pos) < 1: return
    dog.rotation = dog.rotation.lerp(NodeUtils.get_look_at_position_rotation(dog, next_pos), dog.turn_rate)



func _get_random_nearby_position():
    if !pathing_target: return dog.global_position
    var offset_direction := Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized()
    return pathing_target.global_position + offset_direction * wander_offset_max * randf_range(0.75, 1)



func _on_body_entered(body: Node3D):
    if body is not Player: return
    do_pathing = false
    nav_agent.target_position = dog.global_position



func _on_body_exited(body: Node3D):
    if body is not Player || !pathing_target: return
    do_pathing = true
    nav_agent.target_position = pathing_target.global_position
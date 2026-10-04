extends Node3D
class_name ViewPivot

signal interacted(interactable: InteractHandler)
signal notify_interact_look(is_looking: bool)
signal aimed() ## Pulling out the camera to get ready to take picture
signal shot() ## Picture taken while camera is out

@onready var player: Player = owner
@onready var camera: Camera3D = $Camera
@onready var interact_ray: RayCast3D = $InteractRay

var is_aiming: bool = false
var interact_target: InteractHandler = null
var do_camera_bob: bool = false

var bob_theta: float = 0



func toggle_camera_bob(do_bob: bool):
    do_camera_bob = do_bob



func _physics_process(delta):
    # Handle camera bob
    if do_camera_bob:
        camera.rotation.x = deg_to_rad(player.camera_bob_strength * sin(bob_theta))
        camera.rotation.y = deg_to_rad(player.camera_bob_strength / 2 * cos(bob_theta / 2))
        bob_theta += delta * player.move_speed
        bob_theta = fposmod(bob_theta, 4 * PI)
    else:
        bob_theta = 0
        camera.rotation.x = move_toward(camera.rotation.x, 0, delta * player.move_speed)
        camera.rotation.y = move_toward(camera.rotation.y, 0, delta * player.move_speed)

    # Handle interact ray
    if !interact_ray.is_colliding() || interact_ray.get_collider() is not InteractHandler:
        if interact_target != null: notify_interact_look.emit(false)
        interact_target = null
    else:
        if interact_target == null: notify_interact_look.emit(true)
        interact_target = interact_ray.get_collider() as InteractHandler



func _input(event: InputEvent):
    # Handle camera movements
    if event is InputEventMouseMotion && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
        var move = event as InputEventMouseMotion
        player.rotate_y(-move.relative.x * player.mouse_sensitivity)
        rotate_x(-move.relative.y * player.mouse_sensitivity)
        rotation.x = clamp(rotation.x, -deg_to_rad(player.max_up_view_angle), deg_to_rad(player.max_up_view_angle))
        return

    # Handle interactions
    if event.is_action_pressed(Constants.InputNames.Interact) && interact_target != null:
        interact_target.interact(player)
        interacted.emit(interact_target)
        interact_target = null

    # Handle button presses that involve the camera
    if event.is_action_pressed(Constants.InputNames.Aim):
        is_aiming = true
        camera.fov = 55
        aimed.emit()

    elif event.is_action_released(Constants.InputNames.Aim): # TODO: Temp for now, see if this is necessary when camera animation and filter is done
        is_aiming = false
        camera.fov = 75

    if event.is_action_pressed(Constants.InputNames.Shoot) && is_aiming:
        shot.emit()

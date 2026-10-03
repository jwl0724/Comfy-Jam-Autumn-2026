extends Node3D
class_name PlayerCameraController

signal interacted(interactable: InteractHandler)
signal aimed() ## Pulling out the camera to get ready to take picture
signal shot() ## Picture taken while camera is out

@onready var player: Player = owner
@onready var camera: Camera3D = $Camera
@onready var interact_ray: RayCast3D = $InteractRay

var is_aiming: bool = false
var interact_target: InteractHandler = null



func _physics_process(_delta):
    if !interact_ray.is_colliding() || interact_ray.get_collider() is not InteractHandler: interact_target = null
    else: interact_target = interact_ray.get_collider() as InteractHandler



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
        print("TODO: Zoom in the camera and have a camera going up to screen animation")
        is_aiming = true
        camera.fov = 55
        aimed.emit()

    elif event.is_action_released(Constants.InputNames.Aim): # TODO: Temp for now, see if this is necessary when camera animation and filter is done
        is_aiming = false
        camera.fov = 75

    if event.is_action_pressed(Constants.InputNames.Shoot) && is_aiming:
        print("TODO: Take a screenshot of whatever is on screen and do a camera snap effect")
        shot.emit()

extends Node3D
class_name PlayerCameraController

signal aimed() ## Pulling out the camera to get ready to take picture
signal shot() ## Picture taken while camera is out

@onready var player: Player = owner



func _input(event: InputEvent):
    # Handle camera movements
    if event is InputEventMouseMotion && Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
        var move = event as InputEventMouseMotion
        player.rotate_y(-move.relative.x * player.mouse_sensitivity)
        rotate_x(-move.relative.y * player.mouse_sensitivity)
        rotation.x = clamp(rotation.x, -deg_to_rad(player.max_up_view_angle), deg_to_rad(player.max_up_view_angle))
        return

    # Handle button presses that involve the camera
    if Input.is_action_just_pressed(Constants.InputNames.Aim):
        print("TODO: Zoom in the camera and have a camera going up to screen animation")
        aimed.emit()
    if Input.is_action_just_pressed(Constants.InputNames.Shoot):
        print("TODO: Take a screenshot of whatever is on screen only when is aimed down")
        shot.emit()

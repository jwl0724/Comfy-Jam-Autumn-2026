extends Node3D
class_name HeldCamera

const turn_speed: float = 10
const rotation_damp: float = 5 * PI / 4

const sway_offset: float = 0.015
const idle_sway_speed: float = 1
const active_sway_speed: float = 20

@export var pivot: ViewPivot = null
@export var eye_pos: Vector3 = Vector3.ZERO

signal held_to_eye()
signal removed_from_eye()

var base_rotation: Vector3 = Vector3.ZERO
var last_pivot_y: float = 0
var current_offset: float = 0

var baseline_pos: Vector3 = Vector3.ZERO
var current_sway_speed: float = 0
var theta: float = 0

var aim_tween: Tween = null



func _ready():
    base_rotation = global_rotation
    last_pivot_y = pivot.global_rotation.y
    baseline_pos = position

    SignalBus.level_player_hideHeld.connect(_on_hide_request)



func _physics_process(delta):
    if aim_tween && aim_tween.is_running() || !visible:
        # Reset default camera rotations for smooth effect of moving camera to eye
        rotation.z = lerp_angle(rotation.z, base_rotation.z, turn_speed * delta)
        rotation.y = lerp_angle(rotation.y, base_rotation.y, turn_speed * delta)
        return

    # Handle item tilt
    current_offset -= pivot.global_rotation.y - last_pivot_y
    current_offset = lerp_angle(pivot.global_rotation.y - last_pivot_y, 0., turn_speed * delta)
    rotation.y = base_rotation.y + current_offset
    last_pivot_y = pivot.global_rotation.y
    rotation.z = lerp(rotation.z, pivot.global_rotation.x / rotation_damp, turn_speed * delta)

    # Handle item sway
    var target_sway = active_sway_speed if pivot.do_camera_bob else idle_sway_speed
    current_sway_speed = lerp(current_sway_speed, target_sway, turn_speed * delta)
    position = baseline_pos + Vector3.UP * sin(theta) * sway_offset
    theta += current_sway_speed * delta
    if theta > 2 * PI: theta -= 2 * PI



func hold_to_eye():
    if aim_tween && aim_tween.is_running(): aim_tween.kill()

    aim_tween = create_tween()
    aim_tween.tween_property(self, "position", eye_pos, 0.2)
    aim_tween.tween_property(self, "visible", false, 0)
    aim_tween.tween_callback(func(): held_to_eye.emit())
    aim_tween.play()



func remove_from_eye():
    if aim_tween && aim_tween.is_running(): aim_tween.kill()
    visible = true
    removed_from_eye.emit()

    aim_tween = create_tween()
    aim_tween.tween_property(self, "position", baseline_pos, 0.2)
    aim_tween.play()



func _on_hide_request(do_hide: bool):
    if do_hide:
        var t = create_tween()
        t.tween_property(self, "position", Vector3.DOWN, 0.2)
        t.tween_callback(func(): visible = false)
        t.play()
    else:
        position = Vector3.DOWN
        visible = true
        var t = create_tween()
        t.tween_property(self, "position", baseline_pos, 0.2)
        t.play()
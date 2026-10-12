extends Node3D

const turn_speed: float = 10
const rotation_damp: float = 5 * PI / 4

const sway_offset: float = 0.015
const idle_sway_speed: float = 1
const active_sway_speed: float = 20

@export var pivot: ViewPivot = null

var base_rotation: Vector3 = Vector3.ZERO
var last_pivot_y: float = 0
var current_offset: float = 0

var baseline_pos: Vector3 = Vector3.ZERO
var current_sway_speed: float = 0
var theta: float = 0



func _ready():
    base_rotation = global_rotation
    last_pivot_y = pivot.global_rotation.y
    baseline_pos = position



func _physics_process(delta):
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
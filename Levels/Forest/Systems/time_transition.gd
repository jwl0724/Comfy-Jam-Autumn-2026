extends Node
class_name TimeTransition

@export_group("Transition Variables")
@export var sky_top_gradient: GradientTexture1D = null
@export var sky_bot_gradient: GradientTexture1D = null
@export var sun_start_angle: float = -32
@export var sun_end_angle: float = -170

@export_group("Required Nodes")
@export var directional_light: DirectionalLight3D = null
@export var world_environment: WorldEnvironment = null
@export var level_state_handler: LevelStateHandler = null

var sky_material: ShaderMaterial = null



func _ready():
    sky_material = world_environment.environment.sky.sky_material
    directional_light.rotation_degrees.x = sun_start_angle
    sky_material.set_shader_parameter("back_color_top", sky_top_gradient.gradient.sample(0))
    sky_material.set_shader_parameter("back_color_bottom", sky_bot_gradient.gradient.sample(0))



func _physics_process(_delta):
    if level_state_handler.level_timer.is_stopped(): return
    var percent_used: float = (level_state_handler.level_timer.wait_time - level_state_handler.level_timer.time_left) / level_state_handler.level_timer.wait_time

    # Set sun angle
    directional_light.rotation_degrees.x = sun_start_angle + (sun_end_angle - sun_start_angle) * percent_used

    # Set sky color
    sky_material.set_shader_parameter("back_color_top", sky_top_gradient.gradient.sample(percent_used))
    sky_material.set_shader_parameter("back_color_bottom", sky_bot_gradient.gradient.sample(percent_used))
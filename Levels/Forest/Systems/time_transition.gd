extends Node
class_name TimeTransition

@export_group("Transition Variables")
@export var sky_gradient: GradientTexture1D = null
@export var sun_start_angle: float = 0
@export var sun_end_angle: float = 180

@export_group("Required Nodes")
@export var directional_light: DirectionalLight3D = null
@export var sky_shader: ShaderMaterial = null
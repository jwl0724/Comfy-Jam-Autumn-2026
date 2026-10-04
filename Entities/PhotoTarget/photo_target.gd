extends Node3D
class_name PhotoTarget

@export var teleport_points: Array[Node3D] = [] ## Positions in which the target will teleport to if it goes off screen

@onready var visible_notifier = $VisibleNotifier # TODO: Need to have an export on the resource that allows adjusting this value

var model: MeshInstance3D = null
var target_name: String = ""
var behavior_script: GDScript = null # TODO: Might not need this? Assume this is for when implementing moving animals maybe

var was_viewed: bool = false # If target has been seen before
var has_moved: bool = false # Has teleported already
var in_screen: bool = false # When target is in screen (but may not necessarily be in view)
var in_view: bool = false # If target is still within view


# TODO: Need to download some models to make this work
func load_model(model_scene: PackedScene):
    model = model_scene.instantiate()
    add_child(model)



func teleport_to_point(point: Node3D):
    position = point.position
    has_moved = true



func _ready():
    if teleport_points.size() == 0:
        printerr("%s is missing teleport points" % name)
        return
    visible_notifier.screen_entered.connect(_on_screen_entered)
    visible_notifier.screen_exited.connect(_on_screen_exited)



func _physics_process(_delta):
    if !in_screen || has_moved: return
    # Test Ray
    var query := PhysicsRayQueryParameters3D.create(global_position, get_viewport().get_camera_3d().global_position, Constants.PhysLayers.Terrain)
    var collision := get_world_3d().direct_space_state.intersect_ray(query)
    if !collision:
        was_viewed = true
        in_view = true
    else:
        in_view = false
        if was_viewed: teleport_to_point(teleport_points.pick_random())



func _on_screen_entered():
    in_screen = true



func _on_screen_exited():
    in_screen = false
    if was_viewed && !has_moved: teleport_to_point(teleport_points.pick_random())
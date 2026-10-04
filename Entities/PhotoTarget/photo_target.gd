extends Node3D
class_name PhotoTarget

@export var data: PhotoTargetData = null
@export var teleport_points: Array[Node3D] = [] ## Positions in which the target will teleport to if it goes off screen

@onready var visible_notifier = $VisibleNotifier # TODO: Need to have an export on the resource that allows adjusting this value

var model: MeshInstance3D = null
var target_name: String = ""
var behavior_script: GDScript = null # TODO: Might not need this? Assume this is for when implementing moving animals maybe

var was_viewed: bool = false # If target has been seen before
var has_moved: bool = false # Has teleported already
var in_screen: bool = false # When target is in screen (but may not necessarily be in view)
var in_view: bool = false # If target is still within view



func load_data(target_data: PhotoTargetData):
    target_name = target_data.target_name
    behavior_script = target_data.behavior_script
    if target_data.model != null: # TODO: Remove later since all data points should have models, for now keep since no models to use right now
        model = target_data.model.instantiate()
        add_child(model)



func teleport_to_point(point: Node3D):
    position = point.position
    has_moved = true



func _ready():
    if teleport_points.size() == 0:
        printerr("%s is missing teleport points" % name)
        return
    load_data(data)
    visible_notifier.screen_entered.connect(_on_screen_entered)
    visible_notifier.screen_exited.connect(_on_screen_exited)
    SignalBus.level_query_targetView.connect(_on_query_view_request)
    SignalBus.level_query_targetLocations.connect(_on_query_location_request)



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



func _on_query_view_request():
    if !in_screen || global_position.distance_to(get_viewport().get_camera_3d().global_position) > 20: return
    if in_view:
        SignalBus.level_notify_targetView.emit(self)
        return
    # Check if target in view (since physics process stopped raycasting)
    var query := PhysicsRayQueryParameters3D.create(global_position, get_viewport().get_camera_3d().global_position, Constants.PhysLayers.Terrain)
    var collision := get_world_3d().direct_space_state.intersect_ray(query)
    if !collision: SignalBus.level_notify_targetView.emit(self)



func _on_query_location_request():
    SignalBus.level_notify_targetLocation.emit(self)



func _on_screen_entered():
    in_screen = true



func _on_screen_exited():
    in_screen = false
    if was_viewed && !has_moved: teleport_to_point(teleport_points.pick_random())
extends Node3D
class_name PhotoTarget

@export var data: PhotoTargetData = null
@export var teleport_points: Array[Node3D] = [] ## Positions in which the target will teleport to if it goes off screen

@onready var visible_notifier = $VisibleNotifier

const max_detect_distance_squared: float = 20 ** 2
const max_tp_register_distance_squared: float = 90 ** 2

var model: Node3D = null
var target_name: String = ""

var was_viewed: bool = false # If target has been seen before
var has_moved: bool = false # Has teleported already
var in_screen: bool = false # When target is in screen (but may not necessarily be in view)
var in_view: bool = false # If target is still within view
var queued_for_tp: bool = false # If target was viewed once and left the screen again



func load_data(target_data: PhotoTargetData):
	visible_notifier.aabb = target_data.bounding_box
	target_name = target_data.target_name
	model = target_data.model.instantiate()
	add_child(model)



func teleport_to_point(point: Node3D):
	position = point.position
	rotation = point.rotation
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
	if !in_screen || has_moved || global_position.distance_squared_to(get_viewport().get_camera_3d().global_position) > max_tp_register_distance_squared: return

	# Test Ray
	var query := PhysicsRayQueryParameters3D.create(global_position, get_viewport().get_camera_3d().global_position, Constants.PhysLayers.Terrain)
	var collision := get_world_3d().direct_space_state.intersect_ray(query)
	if !collision:
		was_viewed = true
		in_view = true
	else:
		in_view = false
		if was_viewed: queued_for_tp = true



func _on_query_view_request():
	if !in_screen || global_position.distance_squared_to(get_viewport().get_camera_3d().global_position) > max_detect_distance_squared: return
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
	if !queued_for_tp: return
	queued_for_tp = false
	teleport_to_point(teleport_points.pick_random())
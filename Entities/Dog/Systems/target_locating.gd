extends Node
class_name TargetLocating

signal locating(is_locating: bool)

@onready var dog: Dog = owner

var location_key: Dictionary[String, Vector3] = {}
var finished_list: Array[String] = []



func _ready():
    SignalBus.menu_scrapbook_addPhoto.connect(_on_photo_added)
    SignalBus.level_notify_targetLocation.connect(_on_notify_target_location)



func hint_at_target():
    dog.play_interact.emit()

    # Update target locations
    SignalBus.level_query_targetLocations.emit()
    if location_key.size() == 0: return
    locating.emit(true)

    # Find closest target
    var closest := Vector3.INF
    for location in location_key.values():
        if dog.global_position.distance_squared_to(location) < dog.global_position.distance_squared_to(closest):
            closest = location
    _turn_dog_to_position(closest)



func _on_photo_added(_photo: Texture2D, target_name: String):
    finished_list.append(target_name)
    location_key.erase(target_name)



func _on_notify_target_location(target: PhotoTarget):
    if finished_list.has(target.target_name): return
    location_key[target.target_name] = target.global_position



func _turn_dog_to_position(position: Vector3):
    var t = create_tween()
    t.tween_interval(0.5)
    t.tween_callback(func(): dog.play_turn.emit())
    t.tween_property(dog, "rotation", NodeUtils.get_look_at_position_rotation(dog, position), 1.75) # TODO: Fix dog sometimes doing 360 instead of nearest rotation equivalent
    t.tween_interval(dog.interact_handler.interact_time_gap - 1)
    t.tween_callback(func(): locating.emit(false))
    t.play()
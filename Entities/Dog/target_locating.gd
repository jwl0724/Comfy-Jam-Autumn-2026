extends Node
class_name TargetLocating

signal locating(is_locating: bool)

@onready var dog: Dog = owner

var location_key: Dictionary[String, Vector3] = {}
var finished_list: Array[String] = [] # TODO: Need to update scrapbook to allow passing of key, then connect it to the addPhoto signal to know when something is finished so to remove it from location key and add it to finished list



func _ready():
    SignalBus.level_notify_targetLocation.connect(_on_notify_target_location)



func hint_at_target():
    # Update target locations
    locating.emit(true)
    SignalBus.level_query_targetLocations.emit()

    # Find closest target
    var closest := Vector3.INF
    for location in location_key.values():
        if dog.global_position.distance_squared_to(location) < dog.global_position.distance_squared_to(closest):
            closest = location
    _turn_dog_to_position(closest)



func _on_notify_target_location(target: PhotoTarget):
    if finished_list.has(target.target_name): return
    location_key[target.name] = target.global_position



func _turn_dog_to_position(position: Vector3): # TODO: Might need to change how turning is done later? will see based on model
    var original_rotation := dog.rotation
    dog.look_at(position)
    dog.rotation.x = 0
    var target_rotation = dog.rotation
    dog.rotation = original_rotation

    var t = create_tween()
    t.tween_property(dog, "rotation", target_rotation, 1)
    t.tween_interval(dog.interact_handler.interact_time_gap - 1)
    t.tween_callback(func(): locating.emit(false))
    t.play()
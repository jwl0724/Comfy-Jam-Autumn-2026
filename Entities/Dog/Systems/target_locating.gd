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
    # Update target locations
    locating.emit(true)
    SignalBus.level_query_targetLocations.emit()

    # Find closest target
    if location_key.size() == 0: return # TODO: Probably some bark sound effect or something here
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
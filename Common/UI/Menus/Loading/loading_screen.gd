extends ColorRect
class_name LoadingScreen

const fade_time: float = 0.15

signal loading_finished(scene: PackedScene)

@onready var container = $Container

var loading_uid: String = ""
var scene_ready: bool = false
var loaded_scene: PackedScene = null



func _ready():
    container.modulate = Color.TRANSPARENT
    SignalBus.game_transition_fadeShow.emit(Color.WHITE, 0)
    var t = create_tween()
    t.tween_property(container, "modulate", Color.WHITE, fade_time)
    t.play()



func _process(_delta: float):
    if scene_ready || loading_uid == "": return

    var status = ResourceLoader.load_threaded_get_status(loading_uid)
    if status == ResourceLoader.THREAD_LOAD_LOADED:
        scene_ready = true
        loaded_scene = ResourceLoader.load_threaded_get(loading_uid)
        _close_loading_screen()



func thread_load_scene(scene_uid: String):
    loading_uid = scene_uid
    ResourceLoader.load_threaded_request(scene_uid)



func _close_loading_screen():
    SignalBus.game_transition_fadeHide.emit(Color.WHITE, fade_time)
    var t = create_tween()
    t.tween_interval(fade_time)
    t.tween_callback(func(): loading_finished.emit(loaded_scene))
    t.play()
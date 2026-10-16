extends ColorRect
class_name LoadingScreen

const fade_time: float = 0.15

signal loading_finished(scene: PackedScene)

@onready var container = $Container

var loading_uid: String = ""
var scene_ready: bool = false
var loaded_scene: PackedScene = null

var load_tween: Tween = null



func _ready():
    container.modulate = Color.TRANSPARENT
    SignalBus.game_transition_fadeShow.emit(Color.WHITE, 0)
    load_tween = create_tween()
    load_tween.tween_property(container, "modulate", Color.WHITE, fade_time)
    load_tween.play()



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
    SignalBus.audio_stop_music.emit(3)
    if load_tween && load_tween.is_running(): load_tween.kill()
    load_tween = create_tween()
    load_tween.tween_property(container, "modulate", Color.TRANSPARENT, fade_time)
    load_tween.tween_callback(func():
        SignalBus.game_transition_fadeHide.emit(Color.WHITE, 0)
        loading_finished.emit(loaded_scene))

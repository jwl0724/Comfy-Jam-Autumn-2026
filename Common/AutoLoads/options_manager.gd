extends Node

const fov_min: float = 70
const fov_max: float = 100

var music_linear: float = 1
var sfx_linear: float = 1
var fov: float = 75
var mouse_sensitivity_linear: float = 0.5
var is_fullscreen: bool = false



func _ready():
    SignalBus.options_changed_fullscreen.connect(_on_fullscreen)
    SignalBus.options_changed_mouse_sensitivity.connect(_on_mouse_sensitivty_changed)
    SignalBus.options_changed_fov.connect(_on_fov_change)
    SignalBus.options_changed_musicDB.connect(_on_musicDB_change)
    SignalBus.options_changed_sfxDB.connect(_on_sfxDB_change)



func _on_fullscreen(to_fullscreen: bool):
    var mode = DisplayServer.WINDOW_MODE_FULLSCREEN if to_fullscreen else DisplayServer.WINDOW_MODE_WINDOWED
    is_fullscreen = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
    DisplayServer.window_set_mode(mode)



func _on_mouse_sensitivty_changed(linear: float):
    mouse_sensitivity_linear = clampf(linear, 0, 1)



func _on_fov_change(new_value: float):
    fov = clampf(new_value, fov_min, fov_max)



func _on_musicDB_change(linear: float):
    # Don't need to set volume since audio manager already does it
    music_linear = linear



func _on_sfxDB_change(linear: float):
    sfx_linear = linear
extends Control
class_name OptionsMenu

@onready var music_slider: HSlider = %MusicSlider
@onready var music_label: Label = %MusicValue
@onready var sfx_slider: HSlider = %SFXSlider
@onready var sfx_label: Label = %SFXValue
@onready var fov_slider: HSlider = %FOVSlider
@onready var fov_label: Label = %FOVValue
@onready var mouse_sensitivity_slider: HSlider = %MouseSlider
@onready var mouse_label: Label = %MouseValue
@onready var fullscreen_check: CheckBox = %FullscreenCheck



func _ready():
    # Set starting values
    music_slider.max_value = 1
    music_slider.min_value = 0
    sfx_slider.max_value = 1
    sfx_slider.min_value = 0
    fov_slider.max_value = Options.fov_max
    fov_slider.min_value = Options.fov_min
    mouse_sensitivity_slider.max_value = 1
    mouse_sensitivity_slider.min_value = 0
    fullscreen_check.button_pressed = Options.is_fullscreen
    _set_values()

    # Connect sliders to update labels
    music_slider.value_changed.connect(func(f: float): _update_slider(f, music_label, SignalBus.options_changed_musicDB))
    sfx_slider.value_changed.connect(func(f: float): _update_slider(f, sfx_label, SignalBus.options_changed_sfxDB))
    fov_slider.value_changed.connect(func(f: float): _update_slider(f, fov_label, SignalBus.options_changed_fov))
    mouse_sensitivity_slider.value_changed.connect(func(f: float): _update_slider(f, mouse_label, SignalBus.options_changed_mouse_sensitivity))
    fullscreen_check.toggled.connect(func(on: bool): SignalBus.options_changed_fullscreen.emit(on))



func open_options():
    _set_values()



func _set_values():
    music_slider.value = Options.music_linear
    music_label.text = _get_linear_display(music_slider.value)
    sfx_slider.value = Options.sfx_linear
    sfx_label.text = _get_linear_display(sfx_slider.value)
    fov_slider.value = Options.fov
    fov_label.text = "%d" % roundi(fov_slider.value)
    mouse_sensitivity_slider.value = Options.mouse_sensitivity_linear
    mouse_label.text = _get_linear_display(mouse_sensitivity_slider.value)
    fullscreen_check.button_pressed = Options.is_fullscreen



func _update_slider(new_value: float, slider_label: Label, associated_signal: Signal):
    var format: String = _get_linear_display(new_value) if new_value <= 1 else "%d" % roundi(new_value)
    slider_label.text = format
    associated_signal.emit(new_value)



func _get_linear_display(linear: float):
    return "%d" % clamp(roundi(linear * 100), 0, 100)
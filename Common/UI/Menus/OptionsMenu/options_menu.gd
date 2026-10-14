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
    _set_values()



func _set_values():
    pass
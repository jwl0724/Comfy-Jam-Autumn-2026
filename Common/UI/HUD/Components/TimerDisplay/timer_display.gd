extends Control
class_name TimerDisplay

const time_format: String = "%02d:%02d"
const shader_progress_name: String = "progress" # From 1 to 0

const starting_hour: int = 9
const ending_hour: int = 6 + 12

@onready var progress_bar: ColorRect = $Progress
@onready var time_label: Label = $Progress/Time



func _ready():
    visible = true
    progress_bar.material.set_shader_parameter(shader_progress_name, 1)
    _set_time_text(1)

    SignalBus.menu_scrapbook_visible.connect(_on_other_menu_show)
    SignalBus.hud_cameraFilter_visible.connect(_on_other_menu_show)
    SignalBus.hud_timer_update.connect(_on_timer_update)



func _on_timer_update(time_left: float, wait_time: float):
    progress_bar.material.set_shader_parameter(shader_progress_name, time_left / wait_time)
    _set_time_text(time_left / wait_time)



func _on_other_menu_show(to_visible: bool):
    visible = !to_visible



func _set_time_text(percent_progress: float):
    var label_progress = clampf(1 - percent_progress, 0., 1.)
    var minutes_elapsed = roundi(lerpf(starting_hour * 60, ending_hour * 60, label_progress))
    @warning_ignore("integer_division")
    time_label.text = time_format % [minutes_elapsed / 60, minutes_elapsed % 60]

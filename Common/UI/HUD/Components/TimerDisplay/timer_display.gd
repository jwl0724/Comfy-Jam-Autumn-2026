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
    SignalBus.menu_scrapbook_visible.connect(_on_other_menu_show)
    SignalBus.hud_cameraFilter_visible.connect(_on_other_menu_show)
    SignalBus.hud_timer_update.connect(_on_timer_update)



func _on_timer_update(time_left: float, wait_time: float):
    progress_bar.material.set_shader_parameter(shader_progress_name, time_left / wait_time)
    # TODO: Add math for time label



func _on_other_menu_show(to_visible: bool):
    visible = !to_visible
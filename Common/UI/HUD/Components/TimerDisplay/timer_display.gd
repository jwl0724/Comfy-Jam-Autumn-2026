extends Control
class_name TimerDisplay

@onready var progress_bar: ProgressBar = $ProgressBar


func _ready():
    visible = true
    progress_bar.value = progress_bar.max_value
    SignalBus.hud_timer_update.connect(_on_timer_update)



func _on_timer_update(time_left: float, wait_time: float):
    progress_bar.max_value = wait_time
    progress_bar.value = time_left
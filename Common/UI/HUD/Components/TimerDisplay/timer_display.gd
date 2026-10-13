extends Control
class_name TimerDisplay

const fade_in_time: float = 0.25
const travel_distance: float = 20
const time_format: String = "%02d:%02d"

const shader_progress_name: String = "progress" # From 1 to 0
const shader_progress_color: String = "progress_color"
const shader_bg_color: String = "background_color"
const shader_gradient_color: String = "gradient_color"

const starting_hour: int = 9
const ending_hour: int = 6 + 12

@onready var progress_bar: ColorRect = $Progress
@onready var time_label: Label = $Progress/Time

var default_progress_color: Color = Color()
var default_background_color: Color = Color()
var default_gradient_color: Color = Color()



func _ready():
    visible = false
    progress_bar.material.set_shader_parameter(shader_progress_name, 1)
    _set_time_text(1)

    default_progress_color = progress_bar.material.get_shader_parameter(shader_progress_color)
    default_background_color = progress_bar.material.get_shader_parameter(shader_bg_color)
    default_gradient_color = progress_bar.material.get_shader_parameter(shader_gradient_color)

    SignalBus.level_game_start.connect(_play_show_animation)
    SignalBus.menu_scrapbook_visible.connect(_on_other_menu_show)
    SignalBus.hud_cameraFilter_visible.connect(_on_other_menu_show)
    SignalBus.hud_timer_update.connect(_on_timer_update)



func _play_show_animation():
    position = Vector2.UP * travel_distance
    modulate = Color.TRANSPARENT
    visible = true

    var transparent_prog = Color(default_progress_color)
    transparent_prog.a = 0
    var transparent_bg = Color(default_background_color)
    transparent_bg.a = 0
    var transparent_grad = Color(default_gradient_color)
    transparent_grad.a = 0

    var t = create_tween()
    t.set_parallel()
    t.tween_property(self, "modulate", Color.WHITE, fade_in_time)
    t.tween_method(func(c: Color): progress_bar.material.set_shader_parameter(shader_progress_color, c), transparent_prog, default_background_color, fade_in_time)
    t.tween_method(func(c: Color): progress_bar.material.set_shader_parameter(shader_bg_color, c), transparent_bg, default_background_color, fade_in_time)
    t.tween_method(func(c: Color): progress_bar.material.set_shader_parameter(shader_gradient_color, c), transparent_grad, default_gradient_color, fade_in_time)
    t.tween_property(self, "position", Vector2.ZERO, fade_in_time)
    t.set_parallel(false)
    t.play()



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

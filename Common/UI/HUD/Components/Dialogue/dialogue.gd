extends Label
class_name Dialogue

var running_dialogue_tween: Tween = null


# TODO: Looks bad right now, probably need to update the visuals later
func _ready():
    visible = false
    SignalBus.hud_dialogue_play.connect(_on_play_dialogue)



func _on_play_dialogue(sequence: Array[String], time_per_line: float):
    if running_dialogue_tween && running_dialogue_tween.is_running(): return

    visible = true
    running_dialogue_tween = create_tween()

    for line: String in sequence:
        running_dialogue_tween.tween_callback(func():
            visible_ratio = 0
            text = line)
        running_dialogue_tween.tween_property(self, "visible_ratio", 1, time_per_line * 0.3)
        running_dialogue_tween.tween_interval(time_per_line * 0.7) # Leave a little time for reading

    running_dialogue_tween.tween_callback(func(): visible = false)
    running_dialogue_tween.play()
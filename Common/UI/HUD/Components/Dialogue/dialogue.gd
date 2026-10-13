extends Control
class_name Dialogue

var running_dialogue_tween: Tween = null

@onready var dialogue_label: Label = %Dialogue



func _ready():
    visible = false
    modulate = Color.TRANSPARENT
    SignalBus.hud_dialogue_play.connect(_on_play_dialogue)



func _on_play_dialogue(sequence: Array[String], time_per_line: float):
    if running_dialogue_tween && running_dialogue_tween.is_running(): return

    visible = true
    modulate = Color.TRANSPARENT
    dialogue_label.visible_ratio = 0

    running_dialogue_tween = create_tween()
    running_dialogue_tween.tween_property(self, "modulate", Color.WHITE, time_per_line * 0.05)

    for line: String in sequence:
        running_dialogue_tween.tween_callback(func():
            dialogue_label.visible_ratio = 0
            dialogue_label.text = line)
        running_dialogue_tween.tween_property(dialogue_label, "visible_ratio", 1, time_per_line * 0.25)
        running_dialogue_tween.tween_interval(time_per_line * 0.7) # Leave a little time for reading

    running_dialogue_tween.tween_property(self, "modulate", Color.TRANSPARENT, time_per_line * 0.05)
    running_dialogue_tween.tween_callback(func(): visible = false)

    running_dialogue_tween.play()
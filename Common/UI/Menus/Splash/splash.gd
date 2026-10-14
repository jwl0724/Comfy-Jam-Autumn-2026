extends ColorRect

const fade_time: float = 1

@onready var label: Label = $Label



func _ready():
    label.modulate = Color.TRANSPARENT
    var t = create_tween()
    t.tween_interval(fade_time * 2)
    t.tween_property(label, "modulate", Color.WHITE, fade_time)
    t.tween_interval(fade_time * 3)
    t.tween_property(label, "modulate", Color.TRANSPARENT, fade_time)
    t.tween_interval(fade_time)
    t.tween_callback(func():
        SignalBus.game_transition_fadeHide.emit(Color.BLACK, 0)
        SignalBus.game_navigate_mainMenuWithAnimation.emit())
    t.play()
extends ColorRect
class_name LoadingScreen

const fade_time: float = 0.2

signal closed()

@onready var container = $Container



func _ready():
    container.modulate = Color.TRANSPARENT
    var t = create_tween()
    t.tween_property(container, "modulate", Color.WHITE, fade_time)
    t.play()



func _close_loading_screen():
    var t = create_tween()
    t.tween_property(container, "modulate", Color.TRANSPARENT, fade_time)
    t.tween_callback(func(): closed.emit())
    t.play()
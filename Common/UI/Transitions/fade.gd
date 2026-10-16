extends ColorRect
class_name TransitionFade



func _ready():
    SignalBus.game_transition_fadeShow.connect(_on_transition_show_request)
    SignalBus.game_transition_fadeHide.connect(_on_transition_hide_request)
    visible = false



func _on_transition_show_request(new_color: Color, time: float):
    # Set properties
    visible = true
    color = new_color
    modulate = Color.WHITE

    if time == 0: # Skip tweening if time = 0
        visible = false
        modulate = Color.TRANSPARENT
        return

    # Setup transitioning tween
    var t = create_tween()
    t.tween_property(self, "modulate", Color.TRANSPARENT, time)
    t.tween_callback(func(): visible = false)
    t.play()



func _on_transition_hide_request(new_color: Color, time: float):
    # Set properties
    visible = true
    color = new_color
    modulate = Color.TRANSPARENT

    if time == 0: # Skip tweening if time = 0
        modulate = Color.WHITE
        return

    # Setup transitioning tween
    var t = create_tween()
    t.tween_property(self, "modulate", Color.WHITE, time)
    t.play()
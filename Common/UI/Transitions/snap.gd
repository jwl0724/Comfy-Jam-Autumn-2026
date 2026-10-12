extends ColorRect



func _ready():
    visible = false
    modulate = Color.TRANSPARENT
    SignalBus.game_transition_snapEffect.connect(_on_snap_request)



func _on_snap_request(time: float):
    visible = true
    modulate = Color.TRANSPARENT

    var t = create_tween()
    t.tween_property(self, "modulate", Color.WHITE, time / 2)
    t.tween_callback(func(): SignalBus.game_transition_snapCovered.emit())
    t.tween_property(self, "modulate", Color.TRANSPARENT, time / 2)
    t.tween_callback(func(): visible = false)
    t.play()
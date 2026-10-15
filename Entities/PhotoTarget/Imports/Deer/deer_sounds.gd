extends AudioStreamPlayer3D

var sound_loop: Tween = null



func _ready():
    sound_loop = create_tween()
    sound_loop.set_loops(0)
    sound_loop.tween_callback(_try_play)
    sound_loop.tween_interval(8)
    sound_loop.play()



func _try_play():
    if randi() % 3 == 0:
        pitch_scale = randf_range(0.7, 1.1)
        play()
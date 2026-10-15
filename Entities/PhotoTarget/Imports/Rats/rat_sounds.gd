extends Node3D

var sound: AudioStream = preload("uid://7q6syx3ix7vf")
var sound_loop: Tween = null
var audio_player: AudioStreamPlayer3D = null



func _ready():
    audio_player = AudioStreamPlayer3D.new()
    audio_player.bus = Constants.AudioBusNames.DefaultSFX
    audio_player.volume_db = -5
    audio_player.stream = sound
    add_child(audio_player)

    sound_loop = create_tween()
    sound_loop.set_loops(0)
    sound_loop.tween_callback(_try_play)
    sound_loop.tween_interval(10)
    sound_loop.play()



func _try_play():
    if randi() % 3 == 0:
        audio_player.pitch_scale = randf_range(0.9, 1.2)
        audio_player.play()
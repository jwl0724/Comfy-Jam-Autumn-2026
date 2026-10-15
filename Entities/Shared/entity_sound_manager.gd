extends Node3D
class_name EntitySoundManager

var audio_keys: Dictionary[String, AudioStreamPlayer3D] = {}
var pitch_keys: Dictionary[String, Vector2] = {} # x = lower, y = upper



func _ready():
    for audio: AudioStreamPlayer3D in get_children():
        audio_keys[audio.name] = audio
        pitch_keys[audio.name] = Vector2.ONE
        audio.bus = Constants.AudioBusNames.DefaultSFX



func get_audio_player(node_name: String):
    if !_node_exists(audio_keys, node_name): return
    return audio_keys[node_name]



func set_pitch_shift_range(node_name: String, lower: float = 0.9, upper: float = 1.1):
    if lower > upper:
        push_warning("Pitch shift for node %s failed, lower value needs to be less than upper" % node_name)
        return
    if !_node_exists(pitch_keys, node_name): return
    pitch_keys[node_name] = Vector2(lower, upper)



func play_audio(node_name: String, stream: AudioStream):
    if !_node_exists(audio_keys, node_name): return
    var player := audio_keys[node_name]
    var pitch_range := pitch_keys[node_name]
    player.pitch_scale = randf_range(pitch_range.x, pitch_range.y)
    player.stream = stream
    player.play()



func _node_exists(dict: Dictionary, node_name: String):
    if !dict.has(node_name):
        printerr("Unable to find %s in %s" % [node_name, dict])
        return false
    return true
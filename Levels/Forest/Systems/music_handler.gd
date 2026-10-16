extends Node
class_name MusicHandler

const chance_to_play_music_per_frame: float = 0.005 # Have a little randomness on playing music

@export var level_state_handler: LevelStateHandler = null
@export var bgm_collection: Array[AudioStream] = []

@export var percent_used_for_music1: float = 0.2
@export var percent_used_for_music2: float = 0.7

var ready_to_play: bool = false
var can_play_timer: Timer = null
var current_music_index: int = 0
var current_threshold: float = 0



func _ready():
    current_music_index = randi() % bgm_collection.size()
    current_threshold = percent_used_for_music1

    can_play_timer = Timer.new()
    can_play_timer.autostart = false
    can_play_timer.one_shot = false
    can_play_timer.wait_time = bgm_collection[current_music_index].get_length()
    add_child(can_play_timer)

    can_play_timer.timeout.connect(func(): ready_to_play = true && current_threshold != percent_used_for_music2)
    SignalBus.level_game_start.connect(func(): ready_to_play = true)



func _process(_delta):
    if !ready_to_play || level_state_handler.level_timer.is_stopped(): return
    var percent_used: float = (level_state_handler.level_timer.wait_time - level_state_handler.level_timer.time_left) / level_state_handler.level_timer.wait_time
    if percent_used > current_threshold && randf() < chance_to_play_music_per_frame: _signal_to_play()



func _signal_to_play():
    ready_to_play = false
    can_play_timer.start()
    SignalBus.audio_setDB_music.emit(-17.5)
    SignalBus.audio_play_music.emit(bgm_collection[current_music_index], 7.5)
    current_threshold = percent_used_for_music2
    current_music_index = current_music_index + 1 if current_music_index + 1 < bgm_collection.size() else 0
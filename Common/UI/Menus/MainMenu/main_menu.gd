extends Control
class_name MainMenu

@export var camera_snap_sfx: AudioStream = null

@onready var start_button: Button = $Container/Start
@onready var options_button: Button = $Container/Options
@onready var credits_button: Button = $Container/Credits
@onready var quit_button: Button = $Container/Quit



func _ready():
    start_button.pressed.connect(_on_start_pressed)
    options_button.pressed.connect(_on_options_pressed)
    credits_button.pressed.connect(_on_credits_pressed)
    quit_button.pressed.connect(_on_quit_pressed)
    SignalBus.game_transition_fadeShow.emit(Color.BLACK, 1)
# TODO: Probably need to create a load screen scene


func _on_start_pressed():
    SignalBus.game_transition_fadeHide.emit(Color.WHITE, 0.1)
    SignalBus.audio_play_sfx.emit(camera_snap_sfx, false)
    var t = create_tween()
    t.tween_interval(1)
    t.tween_callback(func(): SignalBus.game_navigate_ingame.emit())
    t.play()



func _on_options_pressed():
    print("TODO: Still have to make options menu")



func _on_credits_pressed():
    print("TODO Still have to make credits menu")



func _on_quit_pressed():
    SignalBus.game_transition_fadeHide.emit(Color.BLACK, 1)
    var t = create_tween()
    t.tween_interval(1.2)
    t.tween_callback(func(): SignalBus.game_quit.emit())
    t.play()
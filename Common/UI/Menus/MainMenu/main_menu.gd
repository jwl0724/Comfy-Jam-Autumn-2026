extends Control
class_name MainMenu

const title_default_position: Vector2 = Vector2(0,0)
const title_intro_position: Vector2 = Vector2(0, 80)

const music_fade_time: float = 4

@export var bgm: AudioStream = null
@export var camera_snap_sfx: AudioStream = null

@onready var credits_menu: CreditsMenu = $SubMenus/CreditsMenu

@onready var game_title: Control = $Title
@onready var start_button: Button = $Container/Start
@onready var options_button: Button = $Container/Options
@onready var credits_button: Button = $Container/Credits
@onready var quit_button: Button = $Container/Quit

var intro_tween: Tween = null



func _ready():
    start_button.pressed.connect(_on_start_pressed)
    options_button.pressed.connect(_on_options_pressed)
    credits_button.pressed.connect(_on_credits_pressed)
    quit_button.pressed.connect(_on_quit_pressed)

    SignalBus.game_transition_fadeShow.emit(Color.BLACK, 2)
    SignalBus.audio_crossfade_music.emit(bgm, music_fade_time)



func play_open_sequence():
    game_title.position = title_intro_position

    start_button.modulate = Color.TRANSPARENT
    options_button.modulate = Color.TRANSPARENT
    credits_button.modulate = Color.TRANSPARENT
    quit_button.modulate = Color.TRANSPARENT

    var move_time: float = 1.5
    var fade_time: float = 2.5
    intro_tween = create_tween()
    intro_tween.tween_interval(3)
    intro_tween.tween_property(game_title, "position", title_default_position, move_time)
    intro_tween.parallel().tween_property(start_button, "modulate", Color.WHITE, fade_time)
    intro_tween.parallel().tween_property(options_button, "modulate", Color.WHITE, fade_time)
    intro_tween.parallel().tween_property(credits_button, "modulate", Color.WHITE, fade_time)
    intro_tween.parallel().tween_property(quit_button, "modulate", Color.WHITE, fade_time)
    intro_tween.play()



func _on_start_pressed():
    if intro_tween && intro_tween.is_running(): return

    SignalBus.audio_play_sfx.emit(camera_snap_sfx, false)
    var t = create_tween()
    t.tween_interval(0.15)
    t.tween_callback(func(): SignalBus.game_transition_fadeHide.emit(Color.WHITE, 0.075))
    t.tween_interval(1)
    t.tween_callback(func(): SignalBus.game_navigate_ingame.emit())
    t.play()



func _on_options_pressed():
    if intro_tween && intro_tween.is_running(): return
    SignalBus.options_visible.emit(true)



func _on_credits_pressed():
    if intro_tween && intro_tween.is_running(): return
    var transition_time: float = 0.1
    var t = create_tween()
    t.tween_callback(func(): SignalBus.game_transition_fadeHide.emit(Color.BLACK, transition_time))
    t.tween_interval(transition_time)
    t.tween_callback(func():
        credits_menu.open_credits()
        SignalBus.game_transition_fadeShow.emit(Color.BLACK, transition_time))
    t.tween_interval(transition_time)
    t.tween_callback(func(): credits_menu.activate_scroll())
    t.play()



func _on_quit_pressed():
    if intro_tween && intro_tween.is_running(): return
    SignalBus.game_transition_fadeHide.emit(Color.BLACK, 1)
    SignalBus.audio_stop_music.emit(1)
    var t = create_tween()
    t.tween_interval(1.2)
    t.tween_callback(func(): SignalBus.game_quit.emit())
    t.play()
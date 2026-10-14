extends Control
class_name CreditsMenu

const scroll_speed: float = 30

signal closed_credits()

@onready var credits: RichTextLabel = %CreditsText
@onready var back_button: Button = %Back

var scroll_bar: VScrollBar = null
var do_scroll: bool = false



func _ready():
    visible = false
    scroll_bar = credits.get_v_scroll_bar()
    back_button.pressed.connect(_close_credits)



func _process(delta):
    if !visible || !do_scroll: return
    scroll_bar.value += scroll_speed * delta



func open_credits():
    visible = true



func activate_scroll():
    do_scroll = true



func _close_credits():
    var transition_time: float = 0.1
    var t = create_tween()
    t.tween_callback(func(): SignalBus.game_transition_fadeHide.emit(Color.BLACK, transition_time))
    t.tween_interval(transition_time)
    t.tween_callback(func():
        visible = false
        do_scroll = false
        scroll_bar.value = 0
        closed_credits.emit()
        SignalBus.game_transition_fadeShow.emit(Color.BLACK, transition_time))
    t.tween_interval(transition_time)
    t.play()
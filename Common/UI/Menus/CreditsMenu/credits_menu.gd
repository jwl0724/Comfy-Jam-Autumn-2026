extends Control
class_name CreditsMenu

const scroll_speed: float = 30

signal closed_credits()

@onready var credits: RichTextLabel = %CreditsText
@onready var back_button: Button = %Back

var scroll_bar: VScrollBar = null



func _ready():
    visible = false
    scroll_bar = credits.get_v_scroll_bar()
    back_button.pressed.connect(_close_credits)



func _process(delta):
    if !visible: return
    scroll_bar.value += scroll_speed * delta



func open_credits():
    visible = true



func _close_credits():
    visible = false
    scroll_bar.value = 0
    closed_credits.emit()
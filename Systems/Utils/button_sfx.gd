extends Node

@export var associated_theme: Theme = null
@export var click_sfx: AudioStream = null

const check_criteria := "font_hover_color"
const theme_type := "Button"

var criteria_item: Variant = null



func _ready():
    if associated_theme == null:
        printerr("A theme must be provided for button sfx to be added")
        return
    criteria_item = associated_theme.get_theme_item(Theme.DATA_TYPE_COLOR, check_criteria, theme_type)
    get_tree().node_added.connect(_on_node_added)



func _on_node_added(node: Node):
    if node is not Button: return
    var button = node as Button
    if button.get_theme_color(check_criteria, theme_type) == criteria_item: button.pressed.connect(_on_button_pressed)



func _on_button_pressed():
    SignalBus.audio_play_sfx.emit(click_sfx, true)
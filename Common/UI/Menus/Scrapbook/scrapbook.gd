extends Control

# TODO: Scrapbook looks terrible right now, need to actually improve the visuals later down the road

@onready var close_button: Button = $Close



func _ready():
    visible = false
    SignalBus.menu_scrapbook_visible.connect(_on_scrapbook_request)
    close_button.pressed.connect(_on_close_pressed)



func _on_scrapbook_request(to_visible: bool):
    visible = to_visible
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if to_visible else Input.MOUSE_MODE_CAPTURED



func _on_close_pressed():
    SignalBus.menu_scrapbook_visible.emit(false) # In case other objects require this signalto continue operations
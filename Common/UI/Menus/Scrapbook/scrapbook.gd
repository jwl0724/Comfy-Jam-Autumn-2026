extends Control

# TODO: Scrapbook looks terrible right now, need to actually improve the visuals later down the road

@onready var temp_photo_to_replace: TextureRect = $MarginContainer/GridContainer/Req1
@onready var close_button: Button = $Close


# TODO: Determine requirements and find associated models for them


func _ready():
    visible = false
    SignalBus.menu_scrapbook_visible.connect(_on_scrapbook_request)
    SignalBus.menu_scrapbook_addPhoto.connect(_on_photo_add_request)
    close_button.pressed.connect(_on_close_pressed)



func _on_photo_add_request(photo: Texture2D):
    # TODO: Temp for now just replace the first thing in the scrapbook with a given photo, will probably need to include a key with the signal later
    temp_photo_to_replace.texture = photo



func _on_scrapbook_request(to_visible: bool):
    visible = to_visible
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if to_visible else Input.MOUSE_MODE_CAPTURED



func _on_close_pressed():
    SignalBus.menu_scrapbook_visible.emit(false) # In case other objects require this signalto continue operations
extends Control
class_name PostGame

@onready var title: Label = $Title
@onready var photo_rect: TextureRect = $Container/Photo
@onready var previous_button: Button = $Previous
@onready var next_button: Button = $Next
@onready var menu_button: Button = $Menu

var data_set: Dictionary[String, Texture2D]
var current_index: int = 0



func _ready():
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
    photo_rect.visible = false
    _update_nav_buttons()

    next_button.pressed.connect(_on_next_pressed)
    previous_button.pressed.connect(_on_previous_pressed)
    menu_button.pressed.connect(_on_menu_pressed)

    SignalBus.game_transition_fadeShow.emit(Color.BLACK, 1)



func populate_data(data: Dictionary[String, Texture2D]):
    data_set = data
    photo_rect.visible = data_set.size() > 0
    set_photo()
    _update_nav_buttons()



func set_photo():
    if !photo_rect.visible: return # Don't set anything if no photos were provided
    photo_rect.texture = data_set[data_set.keys()[current_index]]
    title.text = data_set.keys()[current_index]



func _update_nav_buttons():
    if data_set.size() == 0:
        previous_button.visible = false
        next_button.visible = false
        return

    previous_button.visible = current_index != 0
    next_button.visible = current_index != data_set.size() - 1



func _on_next_pressed():
    current_index += 1
    set_photo()
    _update_nav_buttons()



func _on_previous_pressed():
    current_index -= 1
    set_photo()
    _update_nav_buttons()



func _on_menu_pressed():
    var t = create_tween()
    t.tween_callback(func(): SignalBus.game_transition_fadeHide.emit(Color.BLACK, 2))
    t.tween_interval(2)
    t.tween_callback(func(): SignalBus.game_navigate_mainMenu.emit())
    t.play()
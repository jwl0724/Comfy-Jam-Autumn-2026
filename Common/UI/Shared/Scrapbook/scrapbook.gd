extends Control

const entries_per_page: int = 4

@export var transition_time: float = 0.1

@export_group("Required Assets")
@export var page_flip_sfx: AudioStream = null
@export var book_close_sfx: AudioStream = null
@export var book_open_sfx: AudioStream = null

@export var default_texture: Texture2D = null
@export var left_preview_texture: Texture2D = null
@export var right_preview_texture: Texture2D = null

@onready var book: Control = $Container
@onready var book_bg: TextureRect = %BookBackground
@onready var entry_container: GridContainer = %Grid
@onready var close_button: Button = $Close
@onready var page_left: Button = %PageLeft
@onready var page_right: Button = %PageRight

var entry_key: Dictionary[String, ScrapbookEntry] = {}
var current_page: int = 0
var max_pages: int = 0

var filler_texture: Texture2D = null



func _ready():
    visible = false
    max_pages = ceili(entry_container.get_child_count() / float(entries_per_page))
    for entry: ScrapbookEntry in entry_container.get_children():
        entry_key[entry.entry_name] = entry
    filler_texture = entry_key[entry_key.keys()[0]].photo_rect.texture

    SignalBus.menu_scrapbook_requestData.connect(_on_data_request)
    SignalBus.menu_scrapbook_visible.connect(_on_scrapbook_request)
    SignalBus.menu_scrapbook_addPhoto.connect(_on_photo_add_request)

    close_button.pressed.connect(_on_close_pressed)
    page_left.pressed.connect(func(): _on_page_flip_pressed(false))
    page_left.mouse_entered.connect(func(): _on_mouse_entered(true))
    page_left.mouse_exited.connect(_reset_bg_texture)
    page_right.pressed.connect(func(): _on_page_flip_pressed(true))
    page_right.mouse_entered.connect(func(): _on_mouse_entered(false))
    page_right.mouse_exited.connect(_reset_bg_texture)



func _input(event: InputEvent):
    if !visible || event is InputEventMouseMotion: return
    if event.is_action_pressed(Constants.InputNames.Book): _on_close_pressed()



## First page is 0
func flip_page(page: int):
    if current_page == page: return
    if page > max_pages || page < 0:
        printerr("Trying to flip to page %i but it does not exist" % page)
        return

    current_page = page
    for i in range(entry_container.get_child_count()):
        if i >= page * entries_per_page && i < page * entries_per_page + entries_per_page:
            entry_container.get_child(i).visible = true
        else: entry_container.get_child(i).visible = false



func _on_page_flip_pressed(to_right: bool):
    SignalBus.audio_play_sfx.emit(page_flip_sfx, true)
    var page = current_page
    if to_right: page = clampi(current_page + 1, 0, max_pages - 1)
    else: page = clampi(current_page - 1, 0, max_pages - 1)
    flip_page(page)
    _reset_bg_texture()



func _on_data_request():
    var data: Dictionary[String, Texture2D] = {}
    for key in entry_key.keys():
        if entry_key[key].photo_rect.texture == filler_texture: continue
        data[key] = entry_key[key].photo_rect.texture
    SignalBus.menu_scrapbook_sendData.emit(data)



func _on_photo_add_request(photo: Texture2D, target_name: String):
    entry_key[target_name].set_photo(photo)



func _on_scrapbook_request(to_visible: bool):
    if visible == to_visible: return # Skip doing anything if already in same state
    if to_visible:
        SignalBus.level_player_enableControls.emit(false)
        SignalBus.level_player_hideHeld.emit(true)
        SignalBus.audio_play_sfx.emit(book_open_sfx, true)
        visible = true
        close_button.visible = false
        book.position = size.y * Vector2.DOWN

        var t = create_tween()
        t.tween_property(book, "position", Vector2.ZERO, transition_time)
        t.tween_callback(func():
            close_button.visible = true
            Input.mouse_mode = Input.MOUSE_MODE_VISIBLE)
        t.play()

    else:
        close_button.visible = false
        SignalBus.audio_play_sfx.emit(book_close_sfx, true)

        var t = create_tween()
        t.tween_property(book,"position", Vector2.DOWN * size.y, transition_time)
        t.tween_callback(func():
            visible = false
            Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
            SignalBus.level_player_enableControls.emit(true)
            SignalBus.level_player_hideHeld.emit(false))



func _on_close_pressed():
    flip_page(0)
    SignalBus.menu_scrapbook_visible.emit(false) # In case other objects require this signal to continue operations



func _on_mouse_entered(on_left: bool):
    if on_left:
        if current_page == 0: return
        book_bg.texture = left_preview_texture
    else:
        if current_page == max_pages - 1: return
        book_bg.texture = right_preview_texture



func _reset_bg_texture():
    book_bg.texture = default_texture
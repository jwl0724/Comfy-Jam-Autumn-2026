extends Control

# TODO: Scrapbook looks terrible right now, need to actually improve the visuals later down the road

const entries_per_page: int = 4

@onready var entry_container: GridContainer = $Container/Grid
@onready var close_button: Button = $Close
@onready var page_left: Button = $Container/PageLeft
@onready var page_right: Button = $Container/PageRight

var entry_key: Dictionary[String, ScrapbookEntry] = {}
var current_page: int = 0
var max_pages: int = 0



func _ready():
    visible = false
    max_pages = ceili(entry_container.get_child_count() / float(entries_per_page))
    for entry: ScrapbookEntry in entry_container.get_children():
        entry_key[entry.entry_name] = entry

    SignalBus.menu_scrapbook_visible.connect(_on_scrapbook_request)
    SignalBus.menu_scrapbook_addPhoto.connect(_on_photo_add_request)

    close_button.pressed.connect(_on_close_pressed)
    page_left.pressed.connect(func(): _on_page_flip_pressed(false))
    page_right.pressed.connect(func(): _on_page_flip_pressed(true))


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
    var page = current_page
    if to_right: page = clampi(current_page + 1, 0, max_pages - 1)
    else: page = clampi(current_page - 1, 0, max_pages - 1)
    flip_page(page)



func _on_photo_add_request(photo: Texture2D, target_name: String):
    entry_key[target_name].set_photo(photo)



func _on_scrapbook_request(to_visible: bool):
    visible = to_visible
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if to_visible else Input.MOUSE_MODE_CAPTURED



func _on_close_pressed():
    SignalBus.menu_scrapbook_visible.emit(false) # In case other objects require this signalto continue operations
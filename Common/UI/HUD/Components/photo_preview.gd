extends Control
class_name PhotoPreview

# TODO: Need to pause the game timer when the preview is open
# TODO: Probably add a new button to replace a picture in the scrapbook if player takes a better picture

const no_target_text: String = "No Target Detected"
const target_found_text: String = "Picture of a %s"

@onready var requirement_title: Label = $RequirementTitle
@onready var preview: TextureRect = $Container/Photo
@onready var close_button: Button = $Close



func _ready():
    visible = false
    close_button.pressed.connect(_on_close)
    SignalBus.hud_photoPreview_visible.connect(_on_preview_visible_request)
    SignalBus.level_notify_targetView.connect(_on_target_found)



func check_targets():
    SignalBus.level_query_targets.emit()



func _on_preview_visible_request(to_visible: bool, photo: Texture2D):
    visible = to_visible
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if to_visible else Input.MOUSE_MODE_CAPTURED
    if !to_visible: return
    preview.texture = photo
    requirement_title.text = no_target_text
    SignalBus.level_query_targets.emit()



func _on_target_found(target: PhotoTarget):
    requirement_title.text = target_found_text % target.target_name
    SignalBus.menu_scrapbook_addPhoto.emit(preview.texture)



func _on_close():
    SignalBus.hud_photoPreview_visible.emit(false, null)
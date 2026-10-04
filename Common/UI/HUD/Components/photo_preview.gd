extends Control
class_name PhotoPreview

# TODO: Need to change requirement title based on if a requirement was met
# TODO: Need to pause the game timer when the preview is open

const no_target_text: String = "No Target Detected"

@onready var requirement_title: Label = $RequirementTitle
@onready var preview: TextureRect = $Container/Photo
@onready var close_button: Button = $Close




func _ready():
    visible = false
    close_button.pressed.connect(_on_close)
    SignalBus.hud_photoPreview_visible.connect(_on_preview_visible_request)



func _check_requirement(): # TODO: Need to find a criterion on how to check if a photo contains an objective or not, wait until requirements are actually implemented
    return true



func _on_preview_visible_request(to_visible: bool, photo: Texture2D):
    visible = to_visible
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if to_visible else Input.MOUSE_MODE_CAPTURED
    if !to_visible: return
    preview.texture = photo

    if _check_requirement():
        requirement_title.text = "Temp text here, congrats you filled the criteria"
        SignalBus.menu_scrapbook_addPhoto.emit(photo)
    else:
        requirement_title.text = no_target_text



func _on_close():
    SignalBus.hud_photoPreview_visible.emit(false, null)
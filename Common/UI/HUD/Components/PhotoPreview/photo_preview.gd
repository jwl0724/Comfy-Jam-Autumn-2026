extends Control
class_name PhotoPreview



const no_target_text: String = "No Target Detected"
const target_found_text: String = "Picture of a %s"

@onready var requirement_title: Label = $RequirementTitle
@onready var preview: TextureRect = $Container/Photo
@onready var keep_button: Button = $ButtonContainer/Keep
@onready var discard_button: Button = $ButtonContainer/Discard

var current_target: PhotoTarget = null
var found_targets: Array[String] = []



func _ready():
    visible = false
    keep_button.pressed.connect(_on_keep)
    discard_button.pressed.connect(_on_discard)

    SignalBus.hud_photoPreview_visible.connect(_on_preview_visible_request)
    SignalBus.level_notify_targetView.connect(_on_target_found)



func check_targets():
    SignalBus.level_query_targetView.emit()



func _on_preview_visible_request(to_visible: bool, photo: Texture2D):
    current_target = null # Default to if there is no target in image

    visible = to_visible
    keep_button.visible = false
    discard_button.visible = true

    SignalBus.level_player_enableControls.emit(!to_visible)
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if to_visible else Input.MOUSE_MODE_CAPTURED

    if !to_visible: return
    preview.texture = photo
    requirement_title.text = no_target_text
    SignalBus.level_query_targetView.emit()



func _on_target_found(target: PhotoTarget):
    current_target = target
    keep_button.visible = true
    requirement_title.text = target_found_text % target.target_name

    if !found_targets.has(target.target_name):
        found_targets.append(target.target_name)
        discard_button.visible = false



func _on_keep():
    if current_target != null: SignalBus.menu_scrapbook_addPhoto.emit(preview.texture, current_target.target_name)
    current_target = null
    SignalBus.hud_photoPreview_visible.emit(false, null)



func _on_discard():
    current_target = null
    SignalBus.hud_photoPreview_visible.emit(false, null)
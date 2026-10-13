extends Control
class_name PhotoPreview

const no_target_text: String = "No Subject Found"
const target_found_text: String = "Picture of %s"
const slide_time: float = 0.5

@onready var photo_container: MarginContainer = $Container
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

    # Play slide in animation
    var move_distance: float = 75
    requirement_title.visible_ratio = 0
    photo_container.position = Vector2.DOWN * move_distance
    photo_container.modulate = Color.TRANSPARENT
    keep_button.modulate = Color.TRANSPARENT
    keep_button.disabled = true
    discard_button.modulate = Color.TRANSPARENT
    discard_button.disabled = true

    var t = create_tween()
    t.tween_property(photo_container, "position", Vector2.ZERO, slide_time / 2)
    t.parallel().tween_property(photo_container, "modulate", Color.WHITE, slide_time / 2)
    t.parallel().tween_property(keep_button, "modulate", Color.WHITE, slide_time/ 2)
    t.parallel().tween_property(discard_button, "modulate", Color.WHITE, slide_time / 2)
    t.tween_property(requirement_title, "visible_ratio", 1, slide_time / 2)
    t.tween_callback(func():
        discard_button.disabled = false
        keep_button.disabled = false)
    t.play()



func _on_target_found(target: PhotoTarget):
    if current_target == null || _is_closer(target): current_target = target # Check which target is closer to viewpoint
    else: return

    keep_button.visible = true
    requirement_title.text = target_found_text % current_target.target_name

    if !found_targets.has(current_target.target_name):
        found_targets.append(current_target.target_name)
        discard_button.visible = false



func _on_keep():
    if current_target != null: SignalBus.menu_scrapbook_addPhoto.emit(preview.texture, current_target.target_name)
    current_target = null
    SignalBus.hud_photoPreview_visible.emit(false, null)



func _on_discard():
    current_target = null
    SignalBus.hud_photoPreview_visible.emit(false, null)



func _is_closer(new_target: PhotoTarget):
    var player_pos = get_viewport().get_camera_3d().global_position
    return player_pos.distance_squared_to(new_target.global_position) < player_pos.distance_squared_to(current_target.global_position)
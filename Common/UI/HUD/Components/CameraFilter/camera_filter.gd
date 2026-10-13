extends ColorRect
class_name CameraFilter



func _ready():
    visible = false
    SignalBus.hud_cameraFilter_visible.connect(_on_filter_request)



func _on_filter_request(to_visible: bool):
    visible = to_visible
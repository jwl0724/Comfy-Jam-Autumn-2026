extends Control

@onready var interact_prompt: Label = $InteractPrompt

@onready var photo_preview = $PhotoPreview
@onready var scrapbook = $Scrapbook



func _ready():
    # Setup interact prompt
    interact_prompt.visible = false
    SignalBus.hud_interactPrompt_visible.connect(_on_interact_visible_request)
    if OS.has_feature("web"): SignalBus.hud_query_uiOpened.connect(_on_query_ui)



func _on_interact_visible_request(to_visible: bool):
    interact_prompt.visible = to_visible



func _on_query_ui():
    SignalBus.hud_notify_uiOpened.emit(photo_preview.visible || scrapbook.visible)
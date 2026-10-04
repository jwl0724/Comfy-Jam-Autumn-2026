extends Control

func _ready():
    visible = false
    SignalBus.hud_interactPrompt_visible.connect(_on_visible_request)

func _on_visible_request(to_visible: bool):
    visible = to_visible
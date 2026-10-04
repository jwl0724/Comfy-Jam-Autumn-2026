extends Control

@onready var interact_prompt: Label = $InteractPrompt



func _ready():
    # Setup interact prompt
    interact_prompt.visible = false
    SignalBus.hud_interactPrompt_visible.connect(_on_interact_visible_request)



func _on_interact_visible_request(to_visible: bool):
    interact_prompt.visible = to_visible
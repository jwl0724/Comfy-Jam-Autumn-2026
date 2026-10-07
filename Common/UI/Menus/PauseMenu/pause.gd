extends Control
class_name PauseMenu

@onready var confirm_popup: Control = $Popup

@onready var resume_button: Button = %Resume
@onready var options_button: Button = %Options
@onready var quit_button: Button = %Quit
@onready var cancel_button: Button = %Cancel
@onready var menu_button: Button = %MenuButton


func _ready():
    visible = false
    confirm_popup.visible = false

    resume_button.pressed.connect(_on_resume_pressed)
    options_button.pressed.connect(_on_options_pressed)
    quit_button.pressed.connect(_on_quit_pressed)
    menu_button.pressed.connect(_on_menu_button_pressed)
    cancel_button.pressed.connect(_on_cancel_pressed)



func _input(event: InputEvent):
    if event is InputEventMouseMotion: return
    if event.is_action_pressed(Constants.InputNames.Pause) && visible:
        _on_resume_pressed()



func enable_menu(enable: bool):
    visible = enable
    Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if enable else Input.MOUSE_MODE_CAPTURED



func _on_resume_pressed():
    visible = false
    confirm_popup.visible = false
    SignalBus.game_pause.emit(false) # Tells the game controller to unpause the actual game



func _on_options_pressed():
    print("TODO: Create an options menu and connect it to the button here")



func _on_quit_pressed():
    confirm_popup.visible = true



func _on_menu_button_pressed():
    visible = false
    confirm_popup.visible = false
    SignalBus.game_navigate_mainMenu.emit()



func _on_cancel_pressed():
    confirm_popup.visible = false
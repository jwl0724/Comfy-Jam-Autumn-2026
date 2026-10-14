extends Control
class_name PauseMenu

const transition_time: float = 0.25

@onready var menu_container: MarginContainer = $Container
@onready var button_container: Control = %ButtonContainer
@onready var game_title: Control = %Title
@onready var pause_label: Control = %PauseTitle

@onready var confirm_popup: Control = $Popup

@onready var resume_button: Button = %Resume
@onready var options_button: Button = %Options
@onready var quit_button: Button = %Quit
@onready var cancel_button: Button = %Cancel
@onready var menu_button: Button = %MenuButton

var mouse_state_on_pause: Input.MouseMode = Input.MOUSE_MODE_VISIBLE

var animation_tween: Tween = null
var default_left_margin: int = 0
var default_right_margin: int = 0




func _ready():
    visible = false
    confirm_popup.visible = false
    default_left_margin = menu_container.get_theme_constant("margin_left")
    default_right_margin = menu_container.get_theme_constant("margin_right")

    resume_button.pressed.connect(_on_resume_pressed)
    options_button.pressed.connect(_on_options_pressed)
    quit_button.pressed.connect(_on_quit_pressed)
    menu_button.pressed.connect(_on_menu_button_pressed)
    cancel_button.pressed.connect(_on_cancel_pressed)



func _input(event: InputEvent):
    if event is InputEventMouseMotion: return
    if event.is_action_pressed(Constants.InputNames.Pause) && visible:
        get_viewport().set_input_as_handled() # Prevents immediate un-pausing
        _on_resume_pressed()



func enable_menu(enable: bool):
    if enable:
        mouse_state_on_pause = Input.mouse_mode

        visible = true
        resume_button.disabled = true
        options_button.disabled = true
        quit_button.disabled = true
        Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

        button_container.modulate = Color.TRANSPARENT
        pause_label.modulate = Color.TRANSPARENT
        game_title.modulate = Color.TRANSPARENT

        # Animate pause menu
        if animation_tween != null && animation_tween.is_running(): animation_tween.kill()
        animation_tween = create_tween()
        animation_tween.set_parallel(true)
        animation_tween.tween_property(button_container, "modulate", Color.WHITE, transition_time)
        animation_tween.tween_property(pause_label, "modulate", Color.WHITE, transition_time)
        animation_tween.tween_property(game_title, "modulate", Color.WHITE, transition_time)
        animation_tween.tween_method(func(margin: int): menu_container.add_theme_constant_override("margin_left", margin), 0, default_left_margin, transition_time)
        animation_tween.tween_method(func(margin: int): menu_container.add_theme_constant_override("margin_right", margin), 0, default_right_margin, transition_time)
        animation_tween.set_parallel(false)
        animation_tween.tween_callback(func():
            resume_button.disabled = false
            options_button.disabled = false
            quit_button.disabled = false)
        animation_tween.play()

    else:
        visible = false
        menu_container.add_theme_constant_override("margin_left", default_left_margin)
        menu_container.add_theme_constant_override("margin_right", default_right_margin)

        resume_button.disabled = false
        options_button.disabled = false
        quit_button.disabled = false
        Input.mouse_mode = mouse_state_on_pause



func _on_resume_pressed():
    visible = false
    confirm_popup.visible = false
    SignalBus.game_pause.emit(false) # Tells the game controller to unpause the actual game



func _on_options_pressed():
    print("TODO: Create an options menu and connect it to the button here")



func _on_quit_pressed():
    confirm_popup.visible = true



func _on_menu_button_pressed():
    confirm_popup.visible = false
    var t = create_tween()
    t.tween_callback(func(): SignalBus.game_transition_fadeHide.emit(Color.BLACK, 1))
    t.tween_interval(2)
    t.tween_callback(func():
        visible = false
        SignalBus.game_navigate_mainMenu.emit())
    t.play()



func _on_cancel_pressed():
    confirm_popup.visible = false
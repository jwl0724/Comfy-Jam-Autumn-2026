extends CharacterBody3D
class_name Player

# Stats
@export var move_speed: float = 50
@export var fall_speed: float = 10

@export var camera_bob_strength: float = 0.5
@export var mouse_sensitivity: float = 0.005
@export var max_up_view_angle: float = 89

@onready var view_controller: ViewPivot = $Components/Pivot
@onready var move_controller: PlayerMovementController = $Systems/Movement
@onready var screenshot_handler: ScreenshotHandler = $Systems/Screenshot

var controls_enabled: bool = true



func _ready():
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    move_controller.notify_move.connect(_on_move_notify)
    view_controller.notify_interact_look.connect(_on_look_notify)
    view_controller.aimed.connect(_on_aim_down)
    view_controller.shot.connect(_on_photo_shoot)
    SignalBus.level_player_enableControls.connect(func(enable: bool): controls_enabled = enable)



func _input(event: InputEvent):
    if event.is_action_pressed(Constants.InputNames.Pause): # Allows pausing when other UI elements are over it
        print("TODO: Create a pause menu that lets you change options and go back to main menu")
        Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE # Temp until pause menu done

    if event is InputEventMouseMotion || !controls_enabled: return
    if event.is_action_pressed(Constants.InputNames.Book):
        SignalBus.menu_scrapbook_visible.emit(true)



func _on_aim_down():
    print("TODO: Have a camera going up to screen animation then apply a camera display filter on it")



func _on_photo_shoot():
    SignalBus.game_layers_visible.emit(false)
    SignalBus.hud_photoPreview_visible.emit(true, await screenshot_handler.get_screenshot_texture())
    SignalBus.game_layers_visible.emit(true)
    print("TODO: Do a camera snap effect")



func _on_look_notify(is_looking: bool):
    SignalBus.hud_interactPrompt_visible.emit(is_looking)



func _on_move_notify(is_moving: bool):
    view_controller.toggle_camera_bob(is_moving)
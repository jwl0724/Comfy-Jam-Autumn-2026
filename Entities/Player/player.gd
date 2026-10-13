extends CharacterBody3D
class_name Player

@export var force_enable_controls: bool = false

# Stats
@export var move_speed: float = 50
@export var fall_speed: float = 10

@export var camera_bob_strength: float = 0.5
@export var mouse_sensitivity: float = 0.005
@export var max_up_view_angle: float = 89

# Data references
@export var camera_flash_sfx: AudioStream = null

@onready var view_controller: ViewPivot = $Components/Pivot
@onready var move_controller: PlayerMovementController = $Systems/Movement
@onready var screenshot_handler: ScreenshotHandler = $Systems/Screenshot

var controls_enabled: bool = false
var can_pause: bool = true
var is_active: bool = false



func _ready():
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    controls_enabled = GameController.debug_mode && force_enable_controls

    move_controller.notify_move.connect(_on_move_notify)
    view_controller.notify_interact_look.connect(_on_look_notify)
    view_controller.shot.connect(_on_photo_shoot)

    SignalBus.level_player_enableControls.connect(_on_enable_controls)
    SignalBus.level_player_enablePause.connect(_on_enable_pause)
    SignalBus.level_game_start.connect(func(): is_active = true)
    SignalBus.level_game_end.connect(func(): is_active = false)



func _input(event: InputEvent):
    if event.is_action_pressed(Constants.InputNames.Pause) && can_pause: # Allows pausing when other UI elements are over it
        SignalBus.game_pause.emit(true)

    if event is InputEventMouseMotion || !controls_enabled: return
    if event.is_action_pressed(Constants.InputNames.Book):
        SignalBus.menu_scrapbook_visible.emit(true)



func _on_photo_shoot():
    SignalBus.game_transition_snapEffect.emit(0.15)
    SignalBus.audio_play_sfx.emit(camera_flash_sfx, true)
    await SignalBus.game_transition_snapCovered
    SignalBus.game_layers_visible.emit(false)
    view_controller.force_hide_held_camera(true)
    SignalBus.hud_photoPreview_visible.emit(true, await screenshot_handler.get_screenshot_texture())
    view_controller.force_hide_held_camera(false)
    SignalBus.game_layers_visible.emit(true)
    view_controller.reset_held_camera()



func _on_look_notify(is_looking: bool):
    SignalBus.hud_interactPrompt_visible.emit(is_looking)



func _on_move_notify(is_moving: bool):
    view_controller.toggle_camera_bob(is_moving)



func _on_enable_controls(enable: bool):
    controls_enabled = (enable && is_active) || (GameController.debug_mode && force_enable_controls)



func _on_enable_pause(enable: bool):
    can_pause = enable
extends CharacterBody3D
class_name Player

const footstep_player_name: String = "Footstep"
const default_sensitivity: float = 0.005 # The half-way point for linear

@export var force_enable_controls: bool = false

# Stats
@export_group("Stats")
@export var move_speed: float = 50
@export var fall_speed: float = 10
@export var camera_bob_strength: float = 0.5
@export var max_up_view_angle: float = 89

# Data references
@export_group("Required References")
@export var terrain_node: TerraBrush = null

@export_group("Sound Effects")
@export var camera_flash_sfx: AudioStream = null

@export var grass_collection: Array[AudioStream] = []
@export var stone_collection: Array[AudioStream] = []
@export var sand_collection: Array[AudioStream] = []
@export var water_collection: Array[AudioStream] = []

@onready var material_detector: MaterialDetector = $Components/MaterialDetector
@onready var sound_manager: EntitySoundManager = $Components/SoundManager
@onready var view_controller: ViewPivot = $Components/Pivot
@onready var move_controller: PlayerMovementController = $Systems/Movement
@onready var screenshot_handler: ScreenshotHandler = $Systems/Screenshot

var mouse_sensitivity: float = 0.005
var controls_enabled: bool = false
var can_pause: bool = true
var is_active: bool = false

var standing_material := MaterialDetector.MaterialType.GRASS
var footstep_loop: Tween = null



func _ready():
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED # Doesn't do anything on mobile
    controls_enabled = GameController.debug_mode && force_enable_controls

    sound_manager.set_pitch_shift_range(footstep_player_name, 0.8, 1.2)
    footstep_loop = create_tween()
    footstep_loop.set_loops(0)
    footstep_loop.tween_interval(1 / move_speed * 4)
    footstep_loop.tween_callback(_play_step)
    footstep_loop.pause()

    move_controller.notify_move.connect(_on_move_notify)
    view_controller.notify_interact_look.connect(_on_look_notify)
    view_controller.shot.connect(_on_photo_shoot)
    _on_mouse_sensitivity_changed(Options.mouse_sensitivity_linear) # Set sensitivity based off options value

    SignalBus.level_player_enableControls.connect(_on_enable_controls)
    SignalBus.level_player_enablePause.connect(_on_enable_pause)
    SignalBus.level_game_start.connect(func(): is_active = true)
    SignalBus.level_game_end.connect(func(): is_active = false)
    SignalBus.options_changed_mouse_sensitivity.connect(_on_mouse_sensitivity_changed)

    if !OS.has_feature("web"): return
    SignalBus.hud_notify_uiOpened.connect(func(ui_opened: bool): Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if ui_opened else Input.MOUSE_MODE_CAPTURED)



func _physics_process(_delta):
    if terrain_node == null: return
    standing_material = material_detector.check_material(terrain_node)



func _input(event: InputEvent):
    if event.is_action_pressed(Constants.InputNames.Pause) && can_pause: # Allows pausing when other UI elements are over it
        SignalBus.game_pause.emit(true)

    if event is InputEventMouseMotion || !controls_enabled: return
    if event.is_action_pressed(Constants.InputNames.Book):
        SignalBus.menu_scrapbook_visible.emit(true)



func _unhandled_input(event): # Handle to capture the mouse in web build when clicking on screen
    if !OS.has_feature("web"): return
    if event is InputEventMouseButton && event.is_pressed():
        SignalBus.hud_query_uiOpened.emit()



func _on_mouse_sensitivity_changed(linear: float):
    mouse_sensitivity = lerpf(default_sensitivity / 2, default_sensitivity * 2, linear)



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
    if is_moving: footstep_loop.play()
    else: footstep_loop.stop()



func _on_enable_controls(enable: bool):
    controls_enabled = (enable && is_active) || (GameController.debug_mode && force_enable_controls)



func _on_enable_pause(enable: bool):
    can_pause = enable



func _play_step():
    var footstep: AudioStream = null
    match standing_material:
        MaterialDetector.MaterialType.GRASS: footstep = grass_collection.pick_random()
        MaterialDetector.MaterialType.LEAVES: footstep = grass_collection.pick_random()
        MaterialDetector.MaterialType.SAND: footstep = sand_collection.pick_random()
        MaterialDetector.MaterialType.STONE: footstep = stone_collection.pick_random()
        MaterialDetector.MaterialType.SOIL: footstep = grass_collection.pick_random()
        MaterialDetector.MaterialType.WATER: footstep = water_collection.pick_random()
    sound_manager.play_audio(footstep_player_name, footstep)
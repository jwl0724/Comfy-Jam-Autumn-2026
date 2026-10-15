extends CharacterBody3D
class_name Dog

const footstep_player_name: String = "Footstep"
const misc_player_name: String = "Misc"

signal play_bark()
signal play_turn()
signal play_interact()

@export var player_node: Player = null

@export_group("Sound Effects")
@export var bark_collection: Array[AudioStream] = []
@export var interact_sound: AudioStream = null
@export var stone_shift: AudioStream = null
@export var footstep_grass: AudioStream = null
@export var footstep_stone: AudioStream = null
@export var footstep_water: AudioStream = null

@export_group("Stats")
@export var move_speed: float = 8
@export var fall_speed: float = 10
@export var turn_rate: float = 0.25

@onready var interact_handler: InteractHandler = $Components/InteractHandler
@onready var follow_threshold: Area3D = $Components/FollowThreshold
@onready var target_locator: TargetLocating = $Systems/TargetLocating
@onready var pathing_handler: DogPathing = $Systems/Pathing
@onready var sound_manager: EntitySoundManager = $Components/SoundManager

var is_active: bool = false



func _ready():
    sound_manager.set_pitch_shift_range(footstep_player_name, 0.9, 1.3)
    sound_manager.set_pitch_shift_range(misc_player_name)

    play_bark.connect(func(): sound_manager.play_audio(misc_player_name, bark_collection.pick_random()))
    play_turn.connect(func(): sound_manager.play_audio(misc_player_name, stone_shift))
    play_interact.connect(func(): sound_manager.play_audio(misc_player_name, interact_sound))

    target_locator.locating.connect(_on_locating_notify)
    interact_handler.interacted.connect(_on_interact)
    SignalBus.level_game_start.connect(func(): is_active = true)
    SignalBus.level_game_end.connect(func(): is_active = false)



func _on_interact(_player: Player):
    if !is_active: return
    target_locator.hint_at_target()



func _on_locating_notify(is_locating: bool):
    pathing_handler.enable_pathing(!is_locating)
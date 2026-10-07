extends Node

@onready var level_state_handler: LevelStateHandler = $Systems/LevelState
@onready var sequence_handler: SequenceHandler = $Systems/SequenceHandler

@export_group("Required UI")
@export var gui_layer: Array[PackedScene] = []



func _ready():
    level_state_handler.level_ended.connect(_on_level_end)
    sequence_handler.start_sequence_finished.connect(_on_start_sequence_finished)
    sequence_handler.end_sequence_finished.connect(_on_end_sequence_finished)

    SignalBus.level_player_enablePause.emit(false)
    SignalBus.level_player_enableControls.emit(false)
    SignalBus.game_layers_addGUI.emit(GameController.ControlLayers.GUI, gui_layer)
    sequence_handler.call_deferred("play_start_sequence")



func _on_level_end(win: bool):
    if win: sequence_handler.play_win_sequence()
    else: sequence_handler.play_lose_sequence()


# TODO: Below depends on if wanted scripted sequence, determine if scripted sequence is wanted
func _on_start_sequence_finished():
    SignalBus.level_player_enableControls.emit(true)
    level_state_handler.start_level_timer()



func _on_end_sequence_finished():
    SignalBus.level_player_enableControls.emit(false)

extends Node

@onready var level_state_handler: LevelStateHandler = $Systems/LevelState
@onready var sequence_handler: SequenceHandler = $Systems/SequenceHandler



func _ready():
    level_state_handler.level_ended.connect(_on_level_end)
    sequence_handler.start_sequence_finished.connect(_on_start_sequence_finished)
    sequence_handler.end_sequence_finished.connect(_on_end_sequence_finished)

    # TODO: Below depends on if wanted scripted sequence, determine if scripted sequence is wanted
    # SignalBus.level_player_enableControls.emit(false)
    sequence_handler.call_deferred("play_start_sequence")



func _on_level_end(win: bool):
    if win: sequence_handler.play_win_sequence()
    else: sequence_handler.play_lose_sequence()



# TODO: The start/end sequences might not need a signal? for now will just have just in case needed in the future to be determined
func _on_start_sequence_finished():
    SignalBus.level_player_enableControls.emit(true)



func _on_end_sequence_finished():
    SignalBus.level_player_enableControls.emit(false)

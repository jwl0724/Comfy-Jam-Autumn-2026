extends Node
class_name SequenceHandler

signal start_sequence_finished()
signal end_sequence_finished()



func play_start_sequence():
    start_sequence_finished.emit()



func play_win_sequence():
    end_sequence_finished.emit()



func play_lose_sequence():
    end_sequence_finished.emit()
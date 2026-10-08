extends Control
class_name MainMenu



func _ready():
    SignalBus.game_transition_fadeShow.emit(Color.BLACK, 1)
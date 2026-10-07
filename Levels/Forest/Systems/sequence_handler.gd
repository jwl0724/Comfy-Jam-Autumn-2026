extends Node
class_name SequenceHandler

signal start_sequence_finished()
signal end_sequence_finished()

const seconds_per_line: float = 3
const seconds_per_fade: float = 2

const start_dialogue: Array[String] = [
    "Come on Gou, today's our last day here before we move to the city.",
    "I really want to finish my scrapbook collection before we leave.",
    "You're going to help me find everything here Gou!"
]

const win_dialogue: Array[String] = [
    "I think that was the last picture.",
    "We did it Gou! I knew I could always count on you.",
    "Let's go home and show mom and dad, they're gonna be so proud of us!"
]

const lose_dialogue: Array[String] = [
    "Oh no it's getting too dark and I promised mom I wouldn't be out too late.",
    "Come on Gou, let's go home before mom and dad get mad.",
    "I guess somethings just aren't meant to be."
]



func play_start_sequence():
    # TODO: Probably add some scripted actions here?
    var t = create_tween()

    t.tween_callback(func(): SignalBus.game_transition_fadeShow.emit(Color.BLACK, seconds_per_fade))
    t.tween_interval(seconds_per_fade)

    t.tween_callback(func():
        SignalBus.level_player_enableControls.emit(true)
        SignalBus.hud_dialogue_play.emit(start_dialogue, seconds_per_line))
    t.tween_interval(seconds_per_line * start_dialogue.size())

    t.tween_interval(seconds_per_line / 3) # Have a little delay before displaying tutorial messages
    t.tween_callback(func(): SignalBus.hud_tutorial_play.emit())

    t.tween_callback(func(): start_sequence_finished.emit())
    t.play()


# Add fade sequence here, and then open the scrapbook UI here
func play_win_sequence():
    var t = create_tween()

    t.tween_callback(func(): SignalBus.hud_dialogue_play.emit(win_dialogue, seconds_per_line))
    t.tween_interval(seconds_per_line * win_dialogue.size())

    t.tween_callback(func():
        SignalBus.level_player_enableControls.emit(false)
        SignalBus.game_transition_fadeHide.emit(Color.BLACK, seconds_per_fade))
    t.tween_interval(seconds_per_fade)

    t.tween_callback(func(): end_sequence_finished.emit())
    t.play()


# Add fade sequence here, and then open the scrapbook UI here
func play_lose_sequence():
    var t = create_tween()

    t.tween_callback(func(): SignalBus.hud_dialogue_play.emit(lose_dialogue, seconds_per_line))
    t.tween_interval(seconds_per_line * lose_dialogue.size())

    t.tween_callback(func():
        SignalBus.level_player_enableControls.emit(false)
        SignalBus.game_transition_fadeHide.emit(Color.BLACK, seconds_per_fade))
    t.tween_interval(seconds_per_fade)

    t.tween_callback(func(): end_sequence_finished.emit())
    t.play()
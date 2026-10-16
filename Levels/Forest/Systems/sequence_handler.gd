extends Node
class_name SequenceHandler

signal start_sequence_finished()
signal end_sequence_finished()

@export var seconds_per_line: float = 4
@export var seconds_per_fade: float = 2

@export var player: Player = null
@export var dog: Dog = null

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
    "I guess some things just aren't meant to be."
]



func play_start_sequence():
    var t = create_tween()

    # Position actors for intro
    SignalBus.level_player_hideHeld.emit(true)
    player.rotation = Vector3(0, deg_to_rad(16.7), 0)
    player.view_controller.rotation.x = deg_to_rad(-20)
    dog.rotation = NodeUtils.get_look_at_position_rotation(dog, player.position)

    # Fade in from main menu
    t.tween_callback(func(): SignalBus.game_transition_fadeShow.emit(Color.WHITE, seconds_per_fade))
    t.tween_interval(seconds_per_fade)

    # Play dialogue
    t.tween_callback(func(): SignalBus.hud_dialogue_play.emit(start_dialogue, seconds_per_line))
    t.tween_interval(seconds_per_line)

    # Look forwards
    t.tween_property(player, "rotation", Vector3(0, PI / 2, 0), 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
    t.parallel().tween_property(player.view_controller, "rotation", Vector3.ZERO, 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
    t.tween_interval(seconds_per_line - 1)

    # Look back at dog
    t.tween_property(player, "rotation", Vector3(0, deg_to_rad(16.7), 0), 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
    t.parallel().tween_property(player.view_controller, "rotation", Vector3(deg_to_rad(-20), 0, 0), 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
    t.tween_interval(seconds_per_line - 1)

    # Dog barks and turns forward
    t.tween_callback(dog.play_bark.emit)
    t.tween_interval(0.5)
    t.tween_callback(func(): dog.target_locator._turn_dog_to_position(Vector3(0, PI / 2, 0)))

    # Pull out camera and enable controls
    t.tween_property(player, "rotation", Vector3(0, PI / 2, 0), 1.25)
    t.parallel().tween_property(player.view_controller, "rotation", Vector3.ZERO, 1.25)
    t.tween_callback(start_sequence_finished.emit)

    # Add delay before tutorial starts
    t.tween_interval(seconds_per_line / 3)
    t.tween_callback(SignalBus.hud_tutorial_play.emit)
    t.play()



func play_win_sequence():
    SignalBus.level_game_end.emit()
    var t = create_tween()

    t.tween_callback(func(): # Stop player from moving and close all menus
        SignalBus.hud_photoPreview_visible.emit(false, null)
        SignalBus.menu_scrapbook_visible.emit(false)
        SignalBus.level_player_enablePause.emit(false)
        SignalBus.level_player_enableControls.emit(false)
        SignalBus.level_player_hideHeld.emit(true)
        SignalBus.hud_dialogue_play.emit(win_dialogue, seconds_per_line))
    t.tween_interval(seconds_per_line * win_dialogue.size())

    t.tween_callback(func(): SignalBus.game_transition_fadeHide.emit(Color.BLACK, seconds_per_fade))
    t.tween_interval(seconds_per_fade)

    t.tween_callback(func(): end_sequence_finished.emit())
    t.play()



func play_lose_sequence():
    SignalBus.level_game_end.emit()
    var t = create_tween()

    t.tween_callback(func(): # Stop player from moving and close all menus
        SignalBus.hud_photoPreview_visible.emit(false, null)
        SignalBus.menu_scrapbook_visible.emit(false)
        SignalBus.level_player_enableControls.emit(false)
        SignalBus.level_player_enablePause.emit(false)
        SignalBus.level_player_hideHeld.emit(true)
        SignalBus.hud_dialogue_play.emit(lose_dialogue, seconds_per_line))
    t.tween_interval(seconds_per_line * lose_dialogue.size())

    t.tween_callback(func(): SignalBus.game_transition_fadeHide.emit(Color.BLACK, seconds_per_fade))
    t.tween_interval(seconds_per_fade)

    t.tween_callback(func(): end_sequence_finished.emit())
    t.play()
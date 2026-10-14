extends Node
@warning_ignore_start("unused_signal")

# Layers Signals
signal game_layers_visible(visible: bool)
signal game_layers_clearAll()
signal game_layers_addGUI(layer: GameController.ControlLayers, scenes: Array[PackedScene])
signal game_layers_clearGUI(layer: GameController.ControlLayers)

# Transition Signals
signal game_transition_fadeShow(color: Color, time: float) ## A fade transition to show screen
signal game_transition_fadeHide(color: Color, time: float) ## A fade transition to hide screen
signal game_transition_snapEffect(time: float) ## A quick transition when taking a picture
signal game_transition_snapCovered(time: float) ## The exact time when snap is covering screen

# Game Controller Signals
signal game_pause(do_pause: bool)
signal game_quit()
signal game_navigate_mainMenu()
signal game_navigate_ingame()
signal game_navigate_postgame()

# Level Signals for general cases
signal level_time_requestData()
signal level_time_sendData(time_left: float, wait_time: float)
signal level_player_enablePause(enable: bool)
signal level_player_enableControls(enable: bool)
signal level_player_hideHeld(do_hide: bool)
signal level_game_start()
signal level_game_end()

# Level Signals for PhotoTarget
signal level_query_targetView()
signal level_notify_targetView(target: PhotoTarget)
signal level_query_targetLocations()
signal level_notify_targetLocation(target: PhotoTarget)

# HUD Signals
signal hud_cameraFilter_visible(visible: bool)
signal hud_timer_update(time_left: float, wait_time: float)
signal hud_interactPrompt_visible(visible: bool)
signal hud_photoPreview_visible(visible: bool, photo_preview: Texture2D)
signal hud_dialogue_play(dialogue_sequence: Array[String], time_per_line: float)
signal hud_tutorial_play()

# Menu Signals
signal menu_scrapbook_visible(visible: bool)
signal menu_scrapbook_addPhoto(photo: Texture2D, target_name: String)
signal menu_scrapbook_requestData()
signal menu_scrapbook_sendData(photo_key: Dictionary[String, Texture2D])

# Options Signals
signal options_visible(to_visible: bool)
signal options_changed_musicDB(linear: float)
signal options_changed_sfxDB(linear: float)
signal options_changed_fov(new_value: float)
signal options_changed_mouse_sensitivity(linear: float)
signal options_changed_fullscreen(is_fullscreen: bool)

# Audio Signals
signal audio_play_sfx(clip: AudioStream, pitch_shift: bool)
extends Node
@warning_ignore_start("unused_signal")

# Game Controller Signals
signal game_layers_visible(visible: bool)
signal game_pause(do_pause: bool)
signal game_navigate_mainMenu()
signal game_navigate_ingame()

# Level Signals for PhotoTarget
signal level_query_targetView()
signal level_notify_targetView(target: PhotoTarget)
signal level_query_targetLocations()
signal level_notify_targetLocation(target: PhotoTarget)

# HUD Signals
signal hud_interactPrompt_visible(visible: bool)
signal hud_photoPreview_visible(visible: bool, photo_preview: Texture2D)
signal hud_dialogue_play(dialogue_sequence: Array[String], time_per_line: float)

# Menu Signals
signal menu_scrapbook_visible(visible: bool)
signal menu_scrapbook_addPhoto(photo: Texture2D, target_name: String)

# Options Signals
signal options_changed_musicDB(linear: float)
signal options_changed_sfxDB(linear: float)
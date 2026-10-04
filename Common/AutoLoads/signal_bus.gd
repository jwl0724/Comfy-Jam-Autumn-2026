extends Node
@warning_ignore_start("unused_signal")

# Game Controller Signals
signal game_layers_visible(visible: bool)

# Level Signals
signal level_query_targetView()
signal level_notify_targetView(target: PhotoTarget)
signal level_query_targetLocations()
signal level_notify_targetLocation(target: PhotoTarget)

# HUD Signals
signal hud_interactPrompt_visible(visible: bool)
signal hud_photoPreview_visible(visible: bool, photo_preview: Texture2D)

# Menu Signals
signal menu_scrapbook_visible(visible: bool)
signal menu_scrapbook_addPhoto(photo: Texture2D)

# Options Signals
signal options_changed_musicDB(linear: float)
signal options_changed_sfxDB(linear: float)
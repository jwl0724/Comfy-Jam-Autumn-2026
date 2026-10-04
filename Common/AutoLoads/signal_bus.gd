extends Node
@warning_ignore_start("unused_signal")

# HUD Signals
signal hud_interactPrompt_visible(visible: bool)

# Menu Signals
signal menu_scrapbook_visible(visible: bool)

# Options Signals
signal options_changed_musicDB(linear: float)
signal options_changed_sfxDB(linear: float)
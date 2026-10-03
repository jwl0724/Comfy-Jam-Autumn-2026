extends CharacterBody3D
class_name Player

# Stats
@export var move_speed: float = 50
@export var fall_speed: float = 10
@export var mouse_sensitivity: float = 0.005
@export var max_up_view_angle: float = 89



func _ready():
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED



func _input(event: InputEvent):
    if event is InputEventMouseMotion: return
    if Input.is_action_just_pressed(Constants.InputNames.Pause):
        print("TODO: Create a pause menu that lets you change options and go back to main menu")
        Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE # Temp until pause menu done
    if Input.is_action_just_pressed(Constants.InputNames.Interact):
        print("TODO: Interact pressed, need to add a raycast to detect something that is interactable")
    if Input.is_action_just_pressed(Constants.InputNames.Book):
        print("TODO: Book pressed, need to add a UI element that opens a book to review taken photos, and also pauses the game timer when it is open")
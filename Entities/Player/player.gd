extends CharacterBody3D
class_name Player

# Stats
@export var move_speed: float = 50
@export var fall_speed: float = 10
@export var mouse_sensitivity: float = 10



func _input(event: InputEvent):
    if event is not InputEventKey: return
    if Input.is_action_just_pressed(Constants.InputNames.Interact):
        print("TODO: Interact pressed, need to add a raycast to detect something that is interactable")
    if Input.is_action_just_pressed(Constants.InputNames.Book):
        print("TODO: Book pressed, need to add a UI element that opens a book to review taken photos, and also pauses the game timer when it is open")
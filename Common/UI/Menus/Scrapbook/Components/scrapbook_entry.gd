extends Control
class_name ScrapbookEntry

@export var entry_name: String = "" ## Name of the photo entry, the name needs to match the associated photo target research

@onready var photo_rect: TextureRect = $Photo
@onready var photo_label: Label = $PhotoLabel



func _ready():
    photo_label.text = entry_name



func set_photo(photo_texture: Texture2D):
    photo_rect.texture = photo_texture
extends Control

@export var time_per_image: float = 10
@export var image_collection: Array[Texture2D] = []

@onready var bg: TextureRect = $Background
@onready var trans: TextureRect = $Transition
@onready var timer: Timer = $Timer

var current_index: int = 0



func _ready():
    trans.modulate = Color.TRANSPARENT
    timer.wait_time = time_per_image
    timer.one_shot = true
    timer.timeout.connect(_on_timeout)
    timer.start()



func _on_timeout():
    current_index += 1
    if current_index >= image_collection.size(): current_index = 0
    var next_image = image_collection[current_index]
    trans.texture = next_image

    var t = create_tween()
    t.tween_property(trans, "modulate", Color.WHITE, 1)
    t.tween_callback(func(): bg.texture = next_image)
    t.tween_property(trans, "modulate", Color.TRANSPARENT, 0.1)
    t.tween_callback(func(): timer.start())
    t.play()
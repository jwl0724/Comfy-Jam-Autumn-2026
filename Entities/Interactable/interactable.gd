extends Node3D
class_name Interactable

@export var interact_behavior: GDScript = null # TODO: See if this needs to be later down the line, for now just have this be something that disappears once interacted with

@onready var interact_handler: InteractHandler = $InteractHandler



func _ready():
    interact_handler.interacted.connect(_on_interacted)



func _on_interacted(player: Player):
    visible = false
    print("%s interacted with %s" % [player.name, name])
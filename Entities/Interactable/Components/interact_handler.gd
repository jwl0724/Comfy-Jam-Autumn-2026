extends Area3D
class_name InteractHandler

@export var interact_hitbox_shape: Shape3D = null ## The shape to use as the hitbox of the area, ideally should encompass the whole object
@export var interact_limit: int = 1 ## Amount of interactions before being disabled, to have infinite interactions use -1
@export var interact_time_gap: float = 1 ## Amount of delay in seconds before interaction is re-enabled after an interaction

signal interacted(player: Player)

@onready var shape: CollisionShape3D = $Shape
@onready var timer: Timer = $Timer

var interacted_amount: int = 0



func _ready():
    # Set export properties
    if interact_hitbox_shape != null: shape.shape = interact_hitbox_shape
    timer.wait_time = interact_time_gap
    timer.timeout.connect(_on_timeout)

    # Set physics properties
    monitorable = true
    monitoring = false
    collision_layer = Constants.PhysLayers.InteractablePhys



func interact(player: Player):
    interacted_amount += 1
    collision_layer = 0
    interacted.emit(player)
    if interacted_amount < interact_limit || interact_limit == -1: timer.start()



func _on_timeout():
    collision_layer = Constants.PhysLayers.InteractablePhys
extends Area3D
class_name InteractHandler

signal interacted(player: Player)



func _ready():
    monitorable = true
    monitoring = false
    collision_layer = Constants.PhysLayers.Interactable



func interact(player: Player):
    collision_layer = 0
    interacted.emit(player)
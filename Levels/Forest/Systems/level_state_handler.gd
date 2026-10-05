extends Node
class_name LevelHandler

@export var photo_target_node: Node = null

var found_targets: Array[String] = []
var total_targets: int = 0



func _ready():
    total_targets = photo_target_node.get_child_count()
    SignalBus.menu_scrapbook_addPhoto.connect(_on_photo_added)



func _on_photo_added(_photo: Texture2D, target_name: String):
    if found_targets.has(target_name): return
    found_targets.append(target_name)
    if total_targets == found_targets.size():
        SignalBus.level_state_finished.emit()
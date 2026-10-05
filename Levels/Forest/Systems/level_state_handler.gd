extends Node

@export var time_limit_seconds: float = 8 * 60
@export var photo_target_node: Node = null

var found_targets: Array[String] = []
var total_targets: int = 0

var level_timer: Timer = null



func _ready():
    # Create level timer
    level_timer = Timer.new()
    add_child(level_timer)

    level_timer.wait_time = time_limit_seconds
    level_timer.one_shot = true
    level_timer.timeout.connect(_on_timeout)
    level_timer.start()

    total_targets = photo_target_node.get_child_count()
    SignalBus.menu_scrapbook_addPhoto.connect(_on_photo_added)



func _on_photo_added(_photo: Texture2D, target_name: String):
    if found_targets.has(target_name): return
    found_targets.append(target_name)
    if total_targets == found_targets.size():
        print("You win, yay")
        SignalBus.level_state_finished.emit(true)



func _on_timeout():
    print("Womp womp")
    SignalBus.level_state_finished.emit(false)
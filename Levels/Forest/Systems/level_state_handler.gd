extends Node
class_name LevelStateHandler

@export var time_limit_seconds: float = 8 * 60
@export var photo_target_node: Node = null

signal level_ended(win: bool)

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

    total_targets = photo_target_node.get_child_count()
    SignalBus.menu_scrapbook_addPhoto.connect(_on_photo_added)
    SignalBus.level_time_requestData.connect(_on_time_request)



func _process(_delta):
    if level_timer.is_stopped(): return
    SignalBus.hud_timer_update.emit(level_timer.time_left, level_timer.wait_time)



func start_level_timer():
    level_timer.start()



func _on_photo_added(_photo: Texture2D, target_name: String):
    if found_targets.has(target_name): return
    found_targets.append(target_name)
    if total_targets == found_targets.size():
        level_timer.paused = true
        level_ended.emit(true)



func _on_time_request():
    SignalBus.level_time_sendData.emit(level_timer.time_left, level_timer.wait_time)



func _on_timeout():
    level_ended.emit(false)
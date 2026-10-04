extends Node
class_name GameController

static var debug_mode: bool = false

@export var launch_scene: PackedScene = null

@export_group("Dev Tools")
@export var enable_debug: bool = false
@export var debug_scene: PackedScene = null
@export var debug_guis: Array[PackedScene] = []

@onready var gui_layer: Control = $GUI/Root
@onready var pause_layer: Control = $Pause/Root
@onready var transition_layer: Control = $Transition/Root
@onready var debug_layer: Control = $Debug/Root

@onready var running_node: Node3D = $Running



func _ready():
    if !enable_debug:
        change_scenes(launch_scene)
        return

    debug_mode = enable_debug
    if debug_scene: change_scenes(debug_scene)
    else: change_scenes(launch_scene)
    if debug_guis:
        for gui in debug_guis: debug_layer.add_child(gui.instantiate())



func change_scenes(new_scene: PackedScene) -> void:
    if running_node.get_child_count() > 1:
        printerr("Running node should not have more than one child, multiple scenes were added to running")
        return
    if running_node.get_child_count() == 1: running_node.get_child(0).queue_free()
    running_node.add_child(new_scene.instantiate())

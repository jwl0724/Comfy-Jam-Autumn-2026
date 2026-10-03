extends Node
class_name GameController

static var debug_mode: bool = false
@export var enable_debug: bool = false

@export_group("Scene Data")
@export var debug_scene: PackedScene = null
@export var launch_scene: PackedScene = null

@onready var gui_layer: Control = $GUI/Root
@onready var pause_layer: Control = $Pause/Root
@onready var transition_layer: Control = $Transition/Root
@onready var debug_layer: Control = $Debug/Root

@onready var running_node: Node3D = $Running



func _ready():
    debug_mode = enable_debug
    if debug_mode && debug_scene: change_scenes(debug_scene)
    else: change_scenes(launch_scene)



func change_scenes(new_scene: PackedScene) -> void:
    if running_node.get_child_count() > 1:
        printerr("Running node should not have more than one child, multiple scenes were added to running")
        return
    if running_node.get_child_count() == 1: running_node.get_child(0).queue_free()
    running_node.add_child(new_scene.instantiate())

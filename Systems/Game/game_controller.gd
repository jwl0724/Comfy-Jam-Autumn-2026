extends Node
class_name GameController

static var debug_mode: bool = false

enum ControlLayers { GUI, PAUSE, TRANSITION, DEBUG }

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
    SignalBus.game_layers_visible.connect(_on_canvas_layer_visible_request)
    SignalBus.game_layers_clearAll.connect(_on_clear_layers)
    SignalBus.game_layers_addGUI.connect(_on_addGUI)
    SignalBus.game_layers_clearGUI.connect(_on_clearGUI)

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



func _on_canvas_layer_visible_request(to_visible: bool):
    gui_layer.visible = to_visible
    pause_layer.visible = to_visible
    transition_layer.visible = to_visible
    debug_layer.visible = to_visible



func _on_clear_layers():
    NodeUtils.clear_children(gui_layer)
    NodeUtils.clear_children(pause_layer)
    NodeUtils.clear_children(transition_layer)
    NodeUtils.clear_children(debug_layer)



func _on_addGUI(layer: ControlLayers, scenes: Array[PackedScene]):
    var selected: Control = null
    if layer == ControlLayers.GUI: selected = gui_layer
    elif layer == ControlLayers.PAUSE: selected = pause_layer
    elif layer == ControlLayers.TRANSITION: selected = transition_layer
    elif layer == ControlLayers.DEBUG: selected = debug_layer

    for scene in scenes:
        selected.add_child(scene.instantiate())



func _on_clearGUI(layer: ControlLayers):
    if layer == ControlLayers.GUI: NodeUtils.clear_children(gui_layer)
    elif layer == ControlLayers.PAUSE: NodeUtils.clear_children(pause_layer)
    elif layer == ControlLayers.TRANSITION: NodeUtils.clear_children(transition_layer)
    elif layer == ControlLayers.DEBUG: NodeUtils.clear_children(debug_layer)
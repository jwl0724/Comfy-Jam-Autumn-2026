extends CharacterBody3D
class_name Dog

@export var player_node: Player = null

@export_group("Stats")
@export var move_speed: float = 8
@export var fall_speed: float = 10
@export var turn_rate: float = 0.25

@onready var interact_handler: InteractHandler = $Components/InteractHandler
@onready var follow_threshold: Area3D = $Components/FollowThreshold



func _ready():
    interact_handler.interacted.connect(_on_interact)



func _on_interact(_player: Player):
    print("You pet the good boy")
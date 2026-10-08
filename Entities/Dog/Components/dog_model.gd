extends Node3D
class_name DogModel

const move_anim: String = "Armature|Jump"
const idle_anim: String = "Armature|Idle"

const baseline_playback: float = 3.5

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var dog: Dog = owner

# TODO: See if its possible to create custom animations for sniffing and barking

func _ready():
    animation_player.speed_scale = baseline_playback



func _physics_process(_delta):
    if abs(dog.velocity.x) == 0 && abs(dog.velocity.z) == 0:
        if animation_player.current_animation != idle_anim: animation_player.play(idle_anim)
    else:
        if animation_player.current_animation != move_anim: animation_player.play(move_anim)
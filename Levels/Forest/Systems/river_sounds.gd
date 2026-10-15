extends Path3D

@export var player: Player = null
@export var sfx_follower: PathFollow3D = null



func _process(_delta):
    var offset = curve.get_closest_offset(to_local(player.global_position))
    sfx_follower.progress = offset
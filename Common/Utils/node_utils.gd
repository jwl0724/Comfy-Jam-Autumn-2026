class_name NodeUtils

static func clear_children(node: Node):
    for child: Node in node.get_children():
        child.queue_free()



static func get_first_valid(node: Node):
    for child: Node in node.get_children():
        if !child.is_queued_for_deletion() && is_instance_valid(child): return child



static func get_look_at_position_rotation(rotating_node: Node3D, target_pos: Vector3):
    var original_rotation := rotating_node.rotation
    rotating_node.look_at(target_pos)
    rotating_node.rotation.x = 0
    var new_rotation := rotating_node.rotation
    rotating_node.rotation = original_rotation
    return new_rotation
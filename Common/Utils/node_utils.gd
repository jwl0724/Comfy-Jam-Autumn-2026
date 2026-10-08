class_name NodeUtils

static func clear_children(node: Node):
    for child: Node in node.get_children():
        child.queue_free()



static func get_first_valid(node: Node):
    for child: Node in node.get_children():
        if !child.is_queued_for_deletion() && is_instance_valid(child): return child
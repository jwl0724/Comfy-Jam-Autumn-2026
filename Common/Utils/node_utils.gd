class_name NodeUtils

static func clear_children(node: Node):
    for child: Node in node.get_children():
        child.queue_free()
extends Node
class_name ScreenshotHandler



func get_screenshot_texture():
    await RenderingServer.frame_post_draw
    var viewport = get_viewport()
    var image := viewport.get_texture().get_image()
    return ImageTexture.create_from_image(image)

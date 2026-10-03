extends Camera3D
class_name PlayerCameraController

signal moved() ## Any mouse movement that moves viewport
signal aimed() ## Pulling out the camera to get ready to take picture
signal shot() ## Picture taken while camera is out

var player: Player = owner
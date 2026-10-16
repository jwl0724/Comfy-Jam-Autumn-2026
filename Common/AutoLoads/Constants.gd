extends Node

# Physics Layers
class PhysLayers:
    const Terrain: int = 1 # Layer for environment
    const PlayerPhys: int = 2 # Layer for specifically player
    const InteractablePhys: int = 4 # Layer for anything that can be interacted with
    const Objective: int = 8 # Layer for objects that are photo requirements
    const DogPhys: int = 16 # Layer for specifically the dog
    const Ground: int = 32 # Layer for terrain ground
    const Water: int = 64 # Layer for water plane for footstep determination

# Input Map Names
class InputNames:
    const Forward: String = "Forward"
    const Backward: String = "Backward"
    const Left: String = "Left"
    const Right: String = "Right"
    const Interact: String = "Interact"
    const Shoot: String = "Shoot"
    const Aim: String = "Aim"
    const Book: String = "Book"
    const Pause: String = "Pause"
    const WebPause: String = "WebPause"

# Terrabrush Texture Names
class TerraBrushTexturesNames:
    const Grass: String = "Grass"
    const Soil: String = "Soil"
    const Stone: String = "Stone"
    const Leaves: String = "Leaves"
    const Sand: String = "Sand"
    const Roots: String = "Roots"

# Audio Bus Names
class AudioBusNames:
    const DefaultMusic: String = "Default_Music"
    const DefaultSFX: String = "Default_SFX"
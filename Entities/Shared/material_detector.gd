extends RayCast3D
class_name MaterialDetector

enum MaterialType { NONE, WATER, GRASS, STONE, LEAVES, SAND, SOIL } # Roots grouped together with leaves

var water_layer: int = 0


func _ready():
    collision_mask = Constants.PhysLayers.Ground + Constants.PhysLayers.Water
    water_layer = roundi(log(Constants.PhysLayers.Water) / log(2)) + 1



func check_material(terrain: TerraBrush): # Expected to be called every phys frame
    if !is_colliding(): return MaterialType.NONE

    var collider := get_collider()
    if collider is CollisionObject3D && (collider as CollisionObject3D).get_collision_layer_value(water_layer):
        return MaterialType.WATER

    # Handle TerraBrush Terrain
    var local_pos = terrain.to_local(get_collision_point())
    var result := terrain.getPositionInformation(local_pos.x, local_pos.z)
    if result == null: return MaterialType.NONE

    var dominant_texture_name: String = result.get_textures()[0].get_name() # position 0 is most dominant
    match dominant_texture_name:
        Constants.TerraBrushTexturesNames.Grass: return MaterialType.GRASS
        Constants.TerraBrushTexturesNames.Stone: return MaterialType.STONE
        Constants.TerraBrushTexturesNames.Soil: return MaterialType.SOIL
        Constants.TerraBrushTexturesNames.Roots: return MaterialType.LEAVES # Grouped together with leaves, since same footstep sounds
        Constants.TerraBrushTexturesNames.Leaves: return MaterialType.LEAVES
        Constants.TerraBrushTexturesNames.Sand: return MaterialType.SAND
        _: return MaterialType.NONE
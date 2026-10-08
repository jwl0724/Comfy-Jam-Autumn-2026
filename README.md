# Comfy Jam: Autumn 2026 Game

## Requirements
- Comfy/Cozy type game
- Autumn theme
- Must include mechanic where looking away will change something

## Concept
3D Photography game, where you wander a forest with your pet dog to try and take pictures of mushrooms, plants, leaves, and animals to fill a scrapbook with requirements. These items will be scattered around the forest, but the moment the item comes into view for the first time it will enter a state where it turn into some default foliage the moment it goes out of camera view. Ambient noises will occasionally happen that will ideally cause the player to turn their camera towards the source of the sound. The player will be timed to get as much picture as they can before it gets dark, if time allows for it perhaps a special ending for: 1. No pictures taken, 2. Some pictures taken, 3. All pictures taken.

## Implementation
**Player**
- Typical WASD movement, and mouse camera movement
- Right click to take out the camera which will play an animation that applies a filter to the camera (like holding a camera to eye)
- Left click to snap a photo while aiming the camera and evaluate if requirement was in the shot

**Dog**
- Follows player around as default behavior
- Interacting with dog will cause the dog to face a direction and bark at a random requirement

**Photo Requirements**
- Use VisibilityNotifier3D to detect when object is in view and implement logic through that
- On leaving camera view for the first time, the item will move to another set location that doesn't have another requirement on top of it (then the moving will be disabled after moving once)

**Interactables**
- Optional implementation, will see if there is time, if not then just cut this feature
- Spawn interactables and set spawn locations within the forest that differ every run
- Interactables can either boost or hinder player ability to find requirements
    - Ex. Increase movespeed
    - Ex. Temporarily disable items changing when off camera
    - Ex. Highlight photo requirement items
    - Ex. Cause player to pass out and lose a chunk of time


**Level**
- Total 10 minutes to find everything (Adjustable)
- Perhaps tween the color of the skybox to simulate passing of time
- Envisioning a dense forest with lots of orange leaves on the ground and a river within that has an ongoing salmon run


## Credits
### Libraries
https://godotassetlibrary.com/asset/n1tXOr/terrabrush

### Models
https://opengameart.org/content/animated-fish
https://opengameart.org/content/rat-pack
https://opengameart.org/content/deer-low-poly-rigged
https://opengameart.org/content/lowpoly-animated-farm-animal-pack
https://opengameart.org/content/lowpoly-crops-pack
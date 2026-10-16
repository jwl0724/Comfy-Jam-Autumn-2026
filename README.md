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
- Tween the property Back Color Top and Back Color Bottom in skybox.gdshader
- Envisioning a dense forest with lots of orange leaves on the ground and a river within that has an ongoing salmon run


## Credits

### Fonts
https://www.1001fonts.com/sophiecomic-font.html
https://www.1001fonts.com/messy-handwritten-font.html

### Music
https://opengameart.org/content/autumn-forest
https://opengameart.org/content/autumn-lullaby
https://opengameart.org/content/calm-bgm
https://opengameart.org/content/nature-theme-sketch

### Sound Effects
https://pixabay.com/sound-effects/horror-deer-grunt-472371/
https://pixabay.com/sound-effects/film-special-effects-rat-squeaking-sound-effecthd-570216/

https://pixabay.com/sound-effects/nature-nature-at-the-lake-17890/
https://pixabay.com/sound-effects/nature-smooth-cold-wind-looped-135538/
https://pixabay.com/sound-effects/river-ambience-420903/
https://pixabay.com/sound-effects/nature-waterfall-in-jungle-305000/
https://opengameart.org/content/ambient-bird-sounds
https://pixabay.com/sound-effects/nature-cicada-buzzing-331499/
https://pixabay.com/sound-effects/film-special-effects-nature-forest-sound-537925/

https://pixabay.com/sound-effects/film-special-effects-walk-on-dirt-1-291981/
https://pixabay.com/sound-effects/film-special-effects-dry-grass-rustling-478361/
https://pixabay.com/sound-effects/film-special-effects-foot-step-snow-5-189870/
https://pixabay.com/sound-effects/hard-footstep-453022/
https://pixabay.com/sound-effects/film-special-effects-footstep-1-83098/
https://pixabay.com/sound-effects/nature-rustling-grass-4-101281/
https://pixabay.com/sound-effects/nature-rustling-grass-2-101283/

https://pixabay.com/sound-effects/nature-barking-dog-cute-sound-463192/
https://pixabay.com/sound-effects/nature-dog-angry-1-352617/
https://pixabay.com/sound-effects/nature-dog-panting-6862/
https://pixabay.com/sound-effects/nature-dog-bark-382732/
https://pixabay.com/sound-effects/nature-dog-bark-effect-382711/

https://pixabay.com/sound-effects/film-special-effects-camera-appareil-photo-prise-shot-346097/
https://pixabay.com/sound-effects/film-special-effects-page-turn-100277/
https://pixabay.com/sound-effects/technology-camera-13695/
https://pixabay.com/sound-effects/film-special-effects-pageturn-102978/
https://pixabay.com/sound-effects/book-closing-466850/

### Shaders
https://godotshaders.com/shader/simple-blur/
https://godotshaders.com/shader/circular-progress-bar/
https://godotshaders.com/shader/first-person-view-model-shader-updated-for-godot-4-3/
https://godotshaders.com/shader/toon-water-shader/
https://godotshaders.com/shader/anime-style-sky-shader/
https://godotshaders.com/shader/squigglevision/
https://godotshaders.com/shader/kuwahara-shader/
https://godotshaders.com/shader/squiggle-pen-canvas-post-process/
https://godotshaders.com/shader/wiggle-2d/

### Libraries
https://godotassetlibrary.com/asset/n1tXOr/terrabrush

### Art
https://opengameart.org/content/book-cover


### Textures
https://kenney.nl/assets/foliage-sprites
https://freestylized.com/material/ground_08/
https://freestylized.com/material/grass_01/
https://freestylized.com/material/cliff_rocks_05/
https://freestylized.com/material/cliff_rocks_02/
https://freestylized.com/material/ground_with_roots_01/
https://freestylized.com/material/sand_04/


### Models
https://opengameart.org/content/dslr-camera-blender
https://opengameart.org/content/stylized-nature-megakit
https://opengameart.org/content/animated-fish
https://opengameart.org/content/rat-pack
https://opengameart.org/content/deer-low-poly-rigged
https://opengameart.org/content/lowpoly-animated-farm-animal-pack
https://opengameart.org/content/lowpoly-crops-pack
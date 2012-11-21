This is a Crafty component for loading levels created with the [Tiled](http://www.mapeditor.org/) map editor.

## Dependencies
This component depends on jQuery to fetch the file.

## Usage

To load the level:

```map = Crafty.e("TiledLevel").tiledLevel(level.url)```

The level load is asynchronous, so you might want to attach a callback on completion:

```map.bind("TiledLevelLoaded", callback )```

The callback is handed the `TiledLevel` component as an argument.

## Tiled Usage
To assign components to an entity within the Tiled editor, create a "Tiled Property" called `components`.  The value will be a list of the components you want the entity to have on creation.  (It's probably easiest to simply assign a single unique component, and include any others through the `.requires()` funciton in init.)
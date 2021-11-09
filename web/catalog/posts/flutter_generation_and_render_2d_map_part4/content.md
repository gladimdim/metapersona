# Introduction

[In previous post](https://dmytrogladkyi.com/#/catalog/posts/flutter_generation_and_render_2d_map_part3) we finished all the logic related to generation of the map. To be able to apply this feature in  [real game](https://locadeserta.com/sloboda) we need to save and restore the generated map. If we do not do this then each time player starts the game a new map will be generated.

# Requirements

We need to implement (de)serialization logic with following specs:

- Map is serialized to JSON format
- Game can convert Map to JSON (serialize).
- Game can read JSON file and initialize Map (deserialize).

# Implementation

This task is an ideal case for Test Driven Development. We can start adding unit tests that follow such pattern:

- WorldMap constructor is called with custom input values.
- WorldMap is serialized to String variable (json).
- New WorldMap instance is created by deserializing JSON from previous step.
- Compare that custom values on Step 1 and Step 3 are identical.

In this way we will always know that key properties of the map are saved to JSON and can be later deserialized. All properties that are constant or calculable should not be saved to the JSON.

## Serialization Entry Point


The class **WorldMap** gets new method **toJson** that will just return a map with two values width and height.

Here is a unit test for it:

```
  group("(De)serialization", () {
    test("Can serialize and deserialize map dimensions", () {
      var map = WorldMap(width: 5, height: 15);
      var json = map.toJson();
      var newMap = WorldMap.fromJson(json);
      expect(newMap.width, map.width);
      expect(newMap.height, map.height);
    });
  });
```

Implement missing **toJson** and **fromJson** methods:

```
 Map<String, dynamic> toJson() {
    return {"width": width, "height": height};
  }
```

```
  static WorldMap fromJson(Map<String, dynamic> json) {
    return WorldMap(width: json["width"], height: json["height"]);
  }
```

## Serializing List of **Tiles**

Serializing primitive values was easy. The real task is to serialize all those different types of Tiles into JSON in such way that it will be possible to deserialize it back.

Our class properties look like this:

```
class WorldMap {
  final int width;
  final int height;
  List<List<MapTile>> tiles;
  LinkedList<MapTile> river;
}
```

We need to serialize List<List<MapTile>> into an array of array with some Maps.

If you look at **MapTile** class you can notice that it has some primitive values like x and y and an enum with type. This type field will be used in order to distinguish different MapTile in order to call the correct constructor:

```
class MapTile extends LinkedListEntry<MapTile> {
  final int x;
  final int y;
  DIRECTION_TYPES inDirection;
  DIRECTION_TYPES outDirection;

  MAP_TILE_TYPES type;
}
```

At first add tests for **MapTile** (de)serialization:

```
    test("Can (de)serialize Forest Map Tile", () {
      var tile = ForestMapTile(x: 5, y: 3);
      var newTile = MapTile.fromJson(tile.toJson());
      expect(newTile.type, MAP_TILE_TYPES.FOREST);
      expect(newTile.x, tile.x);
      expect(newTile.y, tile.y);
      expect(newTile.inDirection, isNull);
      expect(newTile.outDirection, isNull);
      expect(newTile, isA<ForestMapTile>());
    });
```

And then implement **toJson** and **fromJson** methods:

```
  Map<String, dynamic> toJson() {
    return {
      "x": x,
      "y": y,
      "inDirection": directionTypeToString(inDirection),
      "outDirection": directionTypeToString(outDirection),
      "type": mapTileTypeToString(type),
    };
  }

  static MapTile fromJson(Map<String, dynamic> json) {
    var type = mapTileTypeFromString(json["type"]);
    var x = json["x"];
    var y = json["y"];
    var inDirection = directionTypeFromString(json["inDirection"]);
    var outDirection = directionTypeFromString(json["outDirection"]);
    switch (type) {
      case MAP_TILE_TYPES.RIVER:
        return RiverMapTile(x: x, y: y)
          ..inDirection = inDirection
          ..outDirection = outDirection;
      case MAP_TILE_TYPES.GRASS:
        return GrassMapTile(x: x, y: y);
      case MAP_TILE_TYPES.FOREST:
        return ForestMapTile(x: x, y: y);
      case MAP_TILE_TYPES.LAKE:
        return LakeMapTile(x: x, y: y)
          ..inDirection = inDirection
          ..outDirection = outDirection;
      case MAP_TILE_TYPES.HOME_SETTLEMENT:
        return HomeSettlementMapTile(x: x, y: y);
    }
  }
```

**fromJson** method calls specific class constructors in order to return correct instance. The **type** field is used as a key to determine which class to use.

## (De)serializing lists

The MapTile class and its sublings can be processed. Now we need to iterate over **tiles** to save/restore the map grid.

Add unit test:

```
test("Can serialize and deserialize map grid with tiles", () {
      var map = WorldMap(width: 3, height: 3);
      map.setTile(ForestMapTile(x: 2, y: 2));
      map.setTile(RiverMapTile(x: 0, y: 1));
      var json = map.toJson();
      var newMap = WorldMap.fromJson(json);
      expect(newMap.tileAtPoint(Point(2, 2)), isA<ForestMapTile>());
      expect(newMap.tileAtPoint(Point(2, 2)), isA<RiverMapTile>());
    });
```

It will fail as we do not restore **tiles* list yet.

Update **toJson** method to include **tiles** and **river** properties:
```
  Map<String, dynamic> toJson() {
    return {
      "width": width,
      "height": height,
      "tiles": tiles.map((row) {
        return row.map((mapTile) => mapTile.toJson()).toList();
      }).toList(),
      "river": river.map((e) => e.toJson()).toList()
    };
  }
```

And the same for **fromJson**:

```
static WorldMap fromJson(Map<String, dynamic> json) {
    List tilesJson = json["tiles"];
    List tiles = tilesJson.map<List<MapTile>>((row) {
      return row
          .map<MapTile>((mapTileJson) => MapTile.fromJson(mapTileJson))
          .toList();
    }).toList();

    List riverJson = json["river"];
    var river = LinkedList<MapTile>();
    riverJson.forEach((e) {
      river.add(MapTile.fromJson(e));
    });

    var map = WorldMap(width: json["width"], height: json["height"])
      ..tiles = tiles
      ..river = river;
    return map;
  }
```

Now our tests pass.

# Conclusion

We could use some code generation tools available for Dart:  [json serializable](https://pub.dev/packages/json_serializable). But my personal preference does not like annotations as they add some kind of magic to the code. Also we would have not to forget to rebuild the generated json deserializer functions on each code change to the classes. At first it seems to be a lot of code but it gives us a lot of flexability and you actually do it once and forget about (de)serialization to JSON. 


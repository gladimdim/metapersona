In my game called  ["Loca Deserta: Chumaki"](http://locadeserta.com/index_en.html)  (still WIP) I have an InteractiveWidget widget used as a scroll/pan/zoom surface of the game map.

Different cities are shown on it like this:

![Screenshot_20210606-111616.jpg](https://cdn.hashnode.com/res/hashnode/image/upload/v1622967457323/E3Ztd4ki5.jpeg)

To help navigate the map I decided to add following feature: player should be able to navigate to another city with a button press.

Say like here, to unlock the city you must buy the route to it in another city:

![Untitled.png](https://cdn.hashnode.com/res/hashnode/image/upload/v1622989483835/DpXdKXA4L.png)

And it should nicely animate to the other part of the map, with target City in center:


![ezgif-2-9d2b382b1f0b.gif](https://cdn.hashnode.com/res/hashnode/image/upload/v1622987732013/qqCfyVq_n.gif)


[In my previous post I've shown how to use AnimationController](https://gladimdim.org/animating-interactiveviewer-in-flutter-or-how-to-animate-map-in-your-game) to move from one hardcoded point to another point on a map when the game starts. But in this case we have to react to user action and nicely move the current viewport to the other city.

The technical solution for such feature is split into different tasks:

- Animate InteractiveViewer to zoom + pan to the other City.
- Figure out how to tell InteractiveViewer widget to start moving viewport when player presses button buried deep in the widget tree.

# Animate InteractiveViewer to zoom + pan to the other City

You can read my  [previous post](https://gladimdim.org/animating-interactiveviewer-in-flutter-or-how-to-animate-map-in-your-game) which has detailed description on how to use AnimatedBuilder with Matrix4Tween. In this post I will focus on how to get current Matrix4 value of the InteractiveViewer and use it as a starting point in animation. **(All the variables, widget code, etc is taken from that post).**

Why do we need it? Player does not necessarily position city in the center of the screen and for sure player can zoom in/out the Widget which changes the scale. We should animate movement from any of these combinations to the final destination (another City on a map).

## Setup Animations

In initState we create AnimationController and ask the StateWidget to animate to city called Sich. Each city object has a property 'point' and we know how it is positioned on a map.

```
  @override
  void initState() {
    _animationController =
        AnimationController(duration: animationDuration, vsync: this);
    navigateFromToCity(to: Sich(), withDuration: animationDuration);
    super.initState();
  }
```

## Setup Matrix4 object

Inside **navigateFromToCity** method we have to set starting and final values for our animation.

Read current Matrix4 values from InteractiveViewer:

```
Matrix4 matrixStart = Matrix4.inverted(_transformationController.value);
```

Pay attention to use Matrix4.inverted instead of reading the value directly! If you use just pure _controller.value then you will get weird positions. Remember that InteractiveViewer has a 'viewport' (what you see on screen) that is static . When you pan the map, you are actually moving the 'canvas' in the opposite direction from your finger movement. The viewport does not move, but the canvas does!

You can also use some custom logic to provide any other starting point for the animation, like I have when the game loads for the first time (I animate from the very bottom right to the Sich town):

```
 if (from == null) {
      final startPoint = Point(CANVAS_WIDTH, CANVAS_HEIGHT);
      matrixStart = Matrix4.identity()..translate(startPoint.x, startPoint.y);
}
```

Then calculate the end Point:

```
final endPoint = calculateCenterPointForCity(to);
var end = Matrix4.identity()..translate(endPoint.x, endPoint.y);
```

## Setup Animations and controllers.

```
_mapAnimation = Matrix4Tween(begin: matrixStart, end: end)
        .animate(_animationController);
_animationController.duration = withDuration;
_mapAnimation.addListener(mapAnimationListener);
_mapAnimation.addStatusListener((status) {
if (status == AnimationStatus.completed) {
  _mapAnimation.removeListener(mapAnimationListener);
}
```

Notice that we remove listener to the animation when it is done. Once the animation is finished we no longer need it. That is why we can clean up and do not leak unneeded listeners that are created on each tap.

Reset animation to start from the beginning and play it!

```
_animationController.reset();
_animationController.forward();
```

Each time somebody calls this method the animation sets up the start/end values and starts. We are reusing the same controller for each animation + we remove listener once this one-time-use animation is finished.

Animation part is done.

# Ask InteractiveViewer to move from current view to another City

The button that is used to navigate to another city is buried deep in the widget tree:

![Untitled.png](https://cdn.hashnode.com/res/hashnode/image/upload/v1622989852947/CMkU910VjE.png)

How can we tell InteractiveViewer widget to start moving? We don't have access to it...

Here comes to the rescue the GlobalKey feature that is available in all Widgets. You can read about it at official site:  [https://api.flutter.dev/flutter/foundation/Key-class.html](https://api.flutter.dev/flutter/foundation/Key-class.html)

## Create GlobalKey

Create a global key instance that can be accessed from any part of your code:
```
final globalViewerKey =
    GlobalKey<GameCanvasViewState>(debugLabel: "interactiveViewer");
```

It is a single variable used across the whole application. We do not have to store it inside State of some widget as there can be only one GameCanvas with the map running on screen.

## Use it

Use that key instance in super call when creating GameCanvasView widget
```
class GameCanvasView extends StatefulWidget {
  final Company company;
  final Size screenSize;

  GameCanvasView({required this.company, required this.screenSize})
      : super(key: globalViewerKey);
```

Now anywhere in our code we can get a link to this widget:

```
final viewer = globalViewerKey.currentState;
```

## Send a message to widget to start animation

The feature is almost complete. Just implement onTap event handler to read GameCanvas's state object reference and call a method to navigate from one city to another:
```
  _navigateViewerToCity(City cityThatUnlocks, BuildContext context) {
    final viewer = globalViewerKey.currentState;
    if (viewer == null) {
      return;
    }
    viewer.navigateFromToCity(from: city, to: cityThatUnlocks);
  }
```

And here how it looks in a real game:


![ezgif-2-c90e3ea90d61-2.gif](https://cdn.hashnode.com/res/hashnode/image/upload/v1622989238619/R714fEJpX.gif)

# Summary

With the help of TransformationController we can control how the InteractiveViewer widget should show us our canvas. Animations can smoothly run the map through start and end Matrix4 values, global key can be used to trigger the animation event from any part of our code.
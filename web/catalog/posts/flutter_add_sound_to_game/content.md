[In previous post](https://gladimdim.org/generation-and-render-of-2d-map-with-terrain-in-dart-flutter-deserialization-of-generated-map-part-4-ckf2shxj9025waos12n4lemal)  we learnt how to (de)serialize the map state to and from JSON. Now let's see how can we add sound effects to the game.

# Introduction

Sound effects are a good way to entertain or notify player that something happens. It is also a good feedback source for player actions. For example, in my game  [Loca Deserta: Sloboda](https://locadeserta.com/sloboda/#/) the nature seasons auto switch. The player can miss this event but with sound effect he/she will know that New Year occurred and there might be new events available.

##  Requirements

- Sounds must play in web and native environments

# Implementation

## Choosing Flutter package
[Writing your own channels](https://flutter.dev/docs/development/platform-integration/platform-channels) is a little bit of work :) That is why I selected  [flutter package called Soundpool](https://pub.dev/packages/soundpool).

It is pretty simple to use it:

```
    import 'package:soundpool/soundpool.dart';

    Soundpool pool = Soundpool(streamType: StreamType.notification);

    int soundId = await rootBundle.load("sounds/dices.m4a").then((ByteData soundData)   
                {
                  return pool.load(soundData);
                });
    int streamId = await pool.play(soundId);
```

This package is truly crossplatform and supports iOS, Web and Android. **But! For Web we will have to add one crunch as this package does not work in Safari (iOS and macOS).**

### Naive approach

With only three lines of code we can play sounds in our game.

We can add them to button press handlers and achieve what we want:

```
  return InkWell(
        onTap: () async {
           int soundId = await rootBundle.load("sounds/game_end.m4a").then((ByteData soundData)   
                {
                  return pool.load(soundData);
                });
    int streamId = await pool.play(soundId);
          await Navigator.pushNamed(
              context, PendingChoicableEventScreen.routeName,
              arguments: PendingChoicableEventArguments(
                city: city,
                event: this,
              ));
        },
        child: Stack(...)
```

But such approach becomes quite cumbersome pretty fast and looks more like jQuery-style development. You just inject some sound related code into button event handlers. What if later you want to change the sound played? You will have to find all these event handlers and modify them. This approach is not scalable.

Pros:

- Pretty fast development time
- You don't need to think about architecture

Cons:
- Not scalable
- Very hard to modify
- Sound code is highly coupled with UI code
- If you remove or refactor UI widget with sound code you might forget to add it back.

## Better approach: Create a central place to play the sounds

We will create the **SoundManager** class that will expose methods to play different sounds. These methods can later be used in other parts of UI.

```

class SoundManager {
  Map<String, int> sounds = {};
  SoundManager._internal() {}

  Future initSounds() async {
    if (sounds.isNotEmpty) {
      return;
    }
    await Future.forEach(actionMapping.keys, ((element) async {
      String path = actionMapping[element];
      ByteData soundData = await rootBundle.load(path);
      int soundId;
      soundId = await pool.load(soundData);
      sounds[path] = soundId;
    }));
  }

  Soundpool pool = Soundpool(streamType: StreamType.music);
  static final SoundManager instance = SoundManager._internal();

  playResourceReceived() async {
       await pool.play(sounds[actionMapping["resource_received]]);
  }

  playGameEnd() async {
       await pool.play(sounds[actionMapping["game_end]]);
  }
}

```

In Widget event handlers we can import singleton and play the required sound:

```
InkWell(
        onTap: () {
          SoundManager.instance.playGameEnd();
          Navigator.pop(context);
        },
        child: Row(...)
```

Pros:

- Single registry of available sounds
- API to play different sounds
- Easier to find where different sounds are played

Cons:
- UI code is coupled with sound related code
- Implementer of widget code must not forget to call the SoundManager API in order to play some sound

## State Management to the Rescue!

We can remove all cons points above by reusing my state management approach.

### Some game architecture details

The core logic part of the game is implemented in single class **Sloboda** (a settlement).

Instance of **Sloboda** is available almost in all widgets via Inherited widget. It is allowed to modify the state of the game only via exposed by **Sloboda** class instance  methods.

For example, to complete the task for some building **ResourceBuilding** widget calls method:

```
  completeTaskForBuilding(Taskable task, Building building) {
    addStock(task.output);
    if (task.workersReturn) {
      addCitizens(amount: task.workers);
    }
    building.completeTask(task);
    _innerChanges.add(SLOBODA_ACTIONS.TASK_COMPLETE);
  }
```

The **Sloboda** knows what to do with this type of state modification event. The logic is never scattered all over the UI code.

The last line sends the new message **TASK_COMPLETE** into **BehaviorSubject**:

```
  BehaviorSubject _innerChanges = BehaviorSubject<SLOBODA_ACTIONS>();
```
The subject is hidden from **Sloboda** consumers. This is done in order to control who can make changes to the sloboda task stream: only instance of **Sloboda** class!
The stream from that subject is exposed as a separate public value:

```
  ValueStream<SLOBODA_ACTIONS> changes;

/// in constructor

    changes = _innerChanges.stream;
```

It is allowed to push only values from enum **SLOBODA_ACTION**:

```
enum SLOBODA_ACTIONS {
  NEW_SEASON,
  NEW_YEAR,
  TASK_START,
  TASK_COMPLETE,
  STOCK_ADD,
  STOCK_REMOVE,
  PROPS_ADD,
  PROPS_REMOVE,
  BUILDING_BUILD,
  BUILDING_REMOVE,
  BUILDING_UPGRADE,
  EVENT_ADD,
  EVENT_COMPLETE,
  EVENT_CHOICABLE_ADD,
  EVENT_CHOICABLE_COMPLETE,
  EVENT_IF_ADD
}
```

As you may notice, this is some kind of reversed Redux architecture. We have a store (Sloboda instance), actions to be pushed (SLOBODA_ACTIONS enum) and exposed stream (changes).

### Connecting state management to sound effects

We add new method to **SoundManager** that will subscribe to **sloboda.changes** stream and will play appropriate sound effects for events.

```
  attachToCity(Sloboda city) async {
    await initSounds();
    city.changes.where((event) => actionMapping[event] != null).listen((event) {
      playSound(event);
    });
  }
```

Add new property to **SoundManager** that has a mapping between **SLOBODA_ACTIONS** events and sound files:
```
  Map<SLOBODA_ACTIONS, String> actionMapping = {
    SLOBODA_ACTIONS.TASK_COMPLETE: "assets/sounds/task_complete.mp3",
    SLOBODA_ACTIONS.NEW_YEAR: "assets/sounds/new_year.mp3",
    SLOBODA_ACTIONS.EVENT_ADD: "assets/sounds/event_add.mp3",
    SLOBODA_ACTIONS.EVENT_COMPLETE: "assets/sounds/event_complete.mp3",
    SLOBODA_ACTIONS.EVENT_CHOICABLE_COMPLETE:
        "assets/sounds/event_choicable_complete.mp3",
    SLOBODA_ACTIONS.EVENT_CHOICABLE_ADD:
        "assets/sounds/event_choicable_add.mp3",
  };
```

Full listing of the class:

```

class SoundManager extends SoundManagerClass {
  Map<SLOBODA_ACTIONS, String> actionMapping = {
    SLOBODA_ACTIONS.TASK_COMPLETE: "assets/sounds/task_complete.mp3",
    SLOBODA_ACTIONS.NEW_YEAR: "assets/sounds/new_year.mp3",
    SLOBODA_ACTIONS.EVENT_ADD: "assets/sounds/event_add.mp3",
    SLOBODA_ACTIONS.EVENT_COMPLETE: "assets/sounds/event_complete.mp3",
    SLOBODA_ACTIONS.EVENT_CHOICABLE_COMPLETE:
        "assets/sounds/event_choicable_complete.mp3",
    SLOBODA_ACTIONS.EVENT_CHOICABLE_ADD:
        "assets/sounds/event_choicable_add.mp3",
  };

  Map<String, int> sounds = {};
  SoundManager._internal() {}

  Future initSounds() async {
    if (sounds.isNotEmpty) {
      return;
    }
    await Future.forEach(actionMapping.keys, ((element) async {
      String path = actionMapping[element];
      ByteData soundData = await rootBundle.load(path);
      int soundId;
      soundId = await pool.load(soundData);
      sounds[path] = soundId;
    }));
  }

  Soundpool pool = Soundpool(streamType: StreamType.music);
  static final SoundManager instance = SoundManager._internal();

  playSound(SLOBODA_ACTIONS action) async {
    await pool.play(sounds[actionMapping[action]]);
  }
}
```

Now each time some event happens in the game, the singleton instance of **SoundManager** will play appropriate sound.

Subscription is done via **Sloboda** method:

```
  subscribeSoundManager() {
    return SoundManager.instance.attachToCity(this);
  }
``` 

Pros:

- Does not rely on UI code
- Implementors of Widgets do not have to add sound effect code
- Works from all places, even if the event comes not from the UI action

Cons
- :)

# Make it work in Web

Soundpool has some issues playing sounds in Safari (iOS and macOS). As a workaround I implemented an identical SoundManager class but with web implementation.

Loading web/native classes can be done via conditional imports availalbe in Dart:

```
export 'package:sloboda/models/sound_manager.dart'
    if (dart.library.js) 'package:sloboda/web/models/sound_manager.dart';
```

Both web and native **SoundManager** classes implement the same abstract class **SoundManagerClass**:

```
abstract class SoundManagerClass {
  Map<SLOBODA_ACTIONS, String> actionMapping = Map();
  Map<String, int> sounds = {};
  Future initSounds() async {}

  playSound(SLOBODA_ACTIONS action) async {}

  attachToCity(Sloboda city) async {
    await initSounds();
    city.changes.where((event) => actionMapping[event] != null).listen((event) {
      playSound(event);
    });
  }
}

```

To reliably play the sound on the web we use 'dart:js' library to call JS function. Web version extends it like this:

```
void playWebAudio(String path) {
  js.context.callMethod('playAudio', [path]);
}

class SoundManager extends SoundManagerClass {
  Map<SLOBODA_ACTIONS, String> actionMapping = {
    SLOBODA_ACTIONS.TASK_COMPLETE:
        "/sloboda/assets/assets/sounds/task_complete.mp3",
    SLOBODA_ACTIONS.EVENT_ADD: "/sloboda/assets/assets/sounds/event_add.mp3",
    SLOBODA_ACTIONS.NEW_YEAR: "/sloboda/assets/assets/sounds/new_year.mp3",
    SLOBODA_ACTIONS.EVENT_COMPLETE:
        "/sloboda/assets/assets/sounds/event_complete.mp3",
    SLOBODA_ACTIONS.EVENT_CHOICABLE_COMPLETE:
        "/sloboda/assets/assets/sounds/event_choicable_complete.mp3",
    SLOBODA_ACTIONS.EVENT_CHOICABLE_ADD:
        "/sloboda/assets/assets/sounds/event_choicable_add.mp3",
  };

  Map<String, int> sounds = {};
  SoundManager._internal() {}

  Future initSounds() async {}

  static final SoundManager instance = SoundManager._internal();

  playSound(SLOBODA_ACTIONS action) async {
    print("playing web sound");
    playWebAudio(actionMapping[action]);
  }
}

```

And we need to add a script to the index.html file that contains that 'playAudio' function that calls ** [howler.js](https://howlerjs.com/) ** library:

```
  <script src="https://cdn.jsdelivr.net/npm/howler@2.1.3/dist/howler.min.js"></script>
 <script type="application/javascript">
      var audio;
      function playAudio(path) {
        audio= new Howl({
          src: [path]
        });
        audio.play();
      }
    </script>
```

# Summary

We started from the naive implementation of the sound effect feature by just calling **SoundPool** methods from UI code. Such approach quickly becomes cumbersome and unmaintainable, so we created a special class **SoundManager** that exposed APIs to play different sounds.

Further we enhanced this approach by attaching **SoundManager** to **ValueStream** exposed by the main state class: **Sloboda**. Now each event in the state can have a dedicated sound.

After that we created an abstract class **SoundManagerClass** that is used as a parent for native and web versions of the **SoundManager** class implementations.

The web version (Safari on iOS and macOS) required some crunch to implement, but it was pretty easy to do with 'dart:js' library.
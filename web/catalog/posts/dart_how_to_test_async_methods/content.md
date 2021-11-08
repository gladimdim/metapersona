# Introduction

In my [city building game](https://locadeserta.com/sloboda/) you can gather resources from the map. But at first you need to travel to the location. This takes some time. All the logic related to such tasks is contained inside a **ProgressDuration** class that has such logic:

```
  initTimer() {
    _timer = Timer(duration, () {
      if (isDone()) {
        isFinished = true;
        _innerChanges.add(PROGRESS_DURACTION_EVENTS.FINISHED);
      } else {
        _innerChanges.add(PROGRESS_DURACTION_EVENTS.ACTIVE);
      }
    });
  }

  bool isDone() {
    return finishAt != null && clock.now().compareTo(finishAt) >= 0;
  }
```

The logic relies on the Timer. As it is also a very core part of the game (almost all task based async features use this class), I decided to cover it with unit tests.

# The problem with async logic

The dummy test looks like this:

```
test("Is done after timer is completed", () {
  var task = ProgressDuration();
  task.duration = Duration(seconds: 2);
  task.start();
  ????
  expect(task.isDone, isTrue);
});
```

The test will not wait on the Timer to finish as it executes line-by-line. And it will just call expect function and fail the assertion. Only two seconds later the timer will trigger the callback. So we need to ask dart to wait 2 seconds. Let's try it.

# Naive first tests

```
test("Is done after timer is completed", () async {
  var task = ProgressDuration();
  task.duration = Duration(seconds: 2);
  task.start();
  await Future.delayed(Duration(second: 2));
  expect(task.isDone, isTrue);
});
```

The test is ok. We wait 2 seconds and then check the isDone flag. But imagine you have 100 tests that all wait for couple seconds to finish their flow. This is not correct and should be avoided at any cost. Also such tests are very flakky, you never know if the **microtask** to process your timer callback will be called before or after the **expect** function is called.

What is even worse is that such tests fail randomly. In my case they were 90/100 times successful. Debugging the failed tests cannot help as well: while you sit in debugger the time still passes and all your timers are executed.

Thanks to [TESTING TIMES: ASYNC UNIT TEST WITH DART](https://manichord.com/blog/posts/testing-times.html) article I was able to make my tests correct. Let's do it.

# Fixing the flow

At first we need to wrap our unit tests inside an official  [FakeAsync](https://pub.dev/packages/fake_async) package. It fakes all the timer microtasks and you can even forward time!

Our test will now look like this:

```
 test("(De)serialization of Progress Duration when started", () {
      FakeAsync().run((async) {
        var task = ProgressDuration();
        task.duration = Duration(seconds: 1);
        task.start();
        var newTask = ProgressDuration.fromJson(task.toJson());
        expect(newTask.isStarted, isTrue);
        async.elapse(Duration(seconds: 1));
        expect(newTask.isFinished, isTrue);
      });
    });
```

Notice that the test is now wrapped inside callback function passed as argument to **run**.

Also we use **async.elapse** to forward the timers into the future.

# Finally correct tests!

But here is one additional issue. If your timers or logic relies on DateTime.now() you still will have flakky tests as the **FakeAsync** cannot fake the real system time:  [https://pub.dev/packages/fake_async#integration-with-clock](https://pub.dev/packages/fake_async#integration-with-clock)

This can be solved by replacing all your calls to **DateTime.now()** with **clock.now()**. Clock is another official dart package:  [https://pub.dev/packages/clock](https://pub.dev/packages/clock).

After replacing DateTime.now() with clock.now() all the logic works as before and I have a stable test!

```
  bool isDone() {
    return finishAt != null && clock.now().compareTo(finishAt) >= 0;
  }
```


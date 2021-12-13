Dart team has recently [published a new version of Dart compiler](https://medium.com/dartlang/dart-2-15-7e7a598e508a) with huge enhancements in Isolates worlds.

So everyone is now discovering new possibilities and that you can spawn a subprocess to unlock your main thread to do heavy lifting.

Read more about Isolates: [https://api.dart.dev/stable/2.15.0/dart-isolate/Isolate-class.html](https://api.dart.dev/stable/2.15.0/dart-isolate/Isolate-class.html)

Read my other article [Flutter: Unblocking UI thread with Isolates compute function](http://dmytrogladkyi.com/#/catalog/posts/flutter-unblocking-ui-thread-with-isolates-compute-function)

# GLAD TOOLS

I keep improving my [GladTools](https://github.com/gladimdim/glad_tools/) tool belt from week to week.
This tooling was made for folks like me who do some basic dev tasks by using...online services.
But are you sure they dont leak or that you dont leak important data like JWT tokens, keys, password, endpoints?

So far my GladTools support:
- JSON Parser
- JSON Beautifier
- JWT parser
- URL maker
- Base64 image decoder

As you see, I have to parse JSONs. What happens if you paste a huge JSON into the text field and hit Beautify?

My tool will call jsonDecode in main thread...which potentially can lock your UI thread for unknown amount of time.

This is a bad approach and we must always think possible ways of unlocking the UI thread.

**So I decided to follow the amazing article by [Coding with Andrea](https://codewithandrea.com/articles/parse-large-json-dart-isolates/) and enhanced my code.**

# Basic version JSON Parser in Isolate

From the article and from my older code we can make such snippet that parses JSON in another process:

```
class JsonParserIsolate {
  final String input;

  JsonParserIsolate(this.input);

  Future parseJson() async {
    var port = ReceivePort();
    await Isolate.spawn(_parse, port.sendPort);
    return await port.first;
  }

  Future<void> _parse(SendPort p) async {
    final json = jsonDecode(input);
    Isolate.exit(p, json);
  }
}
```

The code is straightforward to understand. It runs and parses the JSON in separate process.

## But there is a problem

What happens when you send an invalid JSON? 

It turns out that inside the method **_parse** call to **jsonDecode** will throw exception but it never escapes the Isolate!
The exception is not rethrown into the parseJson method, nor to the points where JsonParserIsolate.parseJson was called.

That is why the value or even exception will never be returned.

This line is never executed:
```
return await port.first
```

## How to solve

I figured out a way to inform the caller that the JSON failed to parse. We have to use two ReceivePorts and provide them to the Isolate.spawn like this:

```
var port = ReceivePort();
var errorPort = ReceivePort();
await Isolate.spawn(_parse, port.sendPort, onError: errorPort.sendPort);
```

Both ***port, errorPort*** are streams that we can listen:

```
errorPort.listen((message) {
  // exception thrown INSIDE isolate. Process it!
});

port.listen((message) {
  // everything is good.
  // This is the same as return await port.first; as above
});
```

## How to notify caller of our parseJson?

You see that now we have two listeners to the data/error streams. How can we notify the caller of parseJson about the data or the error?

Use [Completer](https://api.flutter.dev/flutter/dart-async/Completer-class.html)!

This class is underrated by the community as everyone just used to consume Futures/Streams/async calls.

Completer works like this:

1. Instantiate Completer()
2. return completer.future from your method (this is identical to deferred Promises in JavaScript, if someone remembers Q promises there).
3. Inside errorPort/port listeners call the **completer.complete** or **completer.completeError**

Rewritten method:

```
Future parseJson() async {
final completer = Completer();
var port = ReceivePort();
var errorPort = ReceivePort();
await Isolate.spawn(_parse, port.sendPort, onError: errorPort.sendPort);

errorPort.listen((message) {
    // first is Error Message
    // second is stacktrace which is not needed
    List errors = message as List;
    errorPort.close();
    completer.completeError(errors.first);
});

port.listen((message) {
  port.close();
  completer.complete(message);
});

return completer.future;
}
```

I am not sure whether we need to call port.close() in listener, but to make things safer I did it :)

# Full solution

Full listing for jsonDecode called in separate Isolate:

```
class JsonParserIsolate {
  final String input;

  JsonParserIsolate(this.input);

  Future parseJson() async {
    final completer = Completer();
    var port = ReceivePort();
    var errorPort = ReceivePort();
    await Isolate.spawn(_parse, port.sendPort, onError: errorPort.sendPort);

    errorPort.listen((message) {
        // first is Error Message
        // second is stacktrace which is not needed
        List errors = message as List;
        errorPort.close();
        completer.completeError(errors.first);
    });

    port.listen((message) {
      port.close();
      completer.complete(message);
    });

    return completer.future;
  }

  Future<void> _parse(SendPort p) async {
    final json = jsonDecode(input);
    Isolate.exit(p, json);
  }
}
```

# How to use it?

Just like any other method call! Try/catch it to handle errors:

```
void _minify() async {
    var parser = JsonParserIsolate(_controller.text);
    try {
      dynamic input = await parser.parseJson();
      _controller.text = _minifyString(input);
    } catch (e) {
      reportError(e);
    }
}
```



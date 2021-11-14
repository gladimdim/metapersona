# A long time ago...
I have been a fan of Dart language for a very long time. Unfortunately, it was not greeted warmly by 2010- JS community. But the language did not die. A year ago #flutter framework was released by Google. It allows developers to have a single code base for iOS and Android applications. Only very specific platform features must be implemented twice in native code (or just reuse existing plugins which do this). All the code is written in Dart.

But there is another platform with a huge user base: Web. There are no frameworks which can target iOS/Android and Web from the same codebase. There is React Native, but it does not compile to the native code on iOS and Android. It is still a JavaScript running via a native bridge.

At Google I/O 2019, addition to #Flutter framework was released: #Flutter for the web. **Now you can have a single code base but for three different platforms: iOS, Android and Web!** Official site:  [https://flutter.dev/web](https://flutter.dev/web). Also, check the [Official Announcement at Google IO](https://www.youtube.com/watch?v=YSULAJf6R6M&t=1419s)

# How I switched from React to Flutter
I have been working on my own  [project](https://locadeserta.com/index_en.html)  for some time. At first, I decided to do it in ReactJS. I had a lot of experience with it, but doing CSS+HTML is not my thing. I could never understand how to build UI which worked OK in all major browsers in all different sizes. Primarily, my experience was related to building SDKs, APIs, state management. But UI was really hard for me.

Also, for some reason, I could not even run "Hello World" React Native app. That was the last drop. So I decided to look into #Flutter framework one more time. I built the first prototype in 3 days. My coauthor wrote the story for the game, I did the UI. He could replay his story in 3 days!! Doing Flutter was so straightforward that I abandoned ReactJS effort and switched to it.

**The only missing thing for me was the Web**. There are a lot of users, some people prefer to use web apps instead of native apps.

I decided to check how my project (an interactive fiction game) written in 100% Dart code compiles to the web.

As an experiment, I took my animated image widget. It allows to transition between two images (from opacity 1 to 0 and from 0 to 1). Also, I took animation for the slideable button and it works too with 0 changes!

Here is the **same** code **copy-pasted from the Android/iOS app but running in the Chrome:**


![fade_image.gif](screen1.gif)

# Plans for the next year
I am so happy I took #Flutter as my primary framework for the upcoming  [https://locadeserta.com](Loca Deserta, Interactive Fiction Game) release. Once the product features are stabilized I will compile it for the Web.

What are you waiting for? Join #flutter, follow  [@FlutterDev](https://twitter.com/FlutterDev).
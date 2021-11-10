No one knew it was coming. No one even expected it. Everyone was busy watching latest React Conference videos, where thought leaders showed you how to do React correctly. Correct way changes every 1 year, each time better, as they say.

The revolution started in 2009. When the Dart team decided to add its VM into the Chrome. At first as the forked Chrome version, but then their plan was to replace V8 with something supporting normal languages. In 2010 someone [leaked that internal memo](https://gist.github.com/paulmillr/1208618). If you were unfortunate to be a web dev in 2010, you remember how terrible it was (and still is). The Dart team wanted to bring some light to the Dark Age of web development. Instead of getting support from the community, all of the thought leaders of that time rioted. They wanted you to buy their books, ~~Front end master~~ courses, give talks about their new frameworks that could handle only ToDo apps.

They wanted to write posts about

```javascript
NaN <= null // true
NaN > null // true
NaN == null // false
```

And why

```javascript
[] == {} // true
{} == [] // false
```

They did not want to lose that golden goose. The riot was so strong that the Chrome team had to officially promise they would never add DartVM to the browser.

The time passed. Every web dev was busy adopting Backbone (the only normal framework), EmberJS, KnockoutJS, AngularJS, WhateverJS. But the Dart language survived, thanks to one of the most influential person in Google. And they decided to keep everything under the radar. No more talks with committees. No more public discussions.

Dart evolved. You could use it with AngularDart.  [Some of the companies](https://www.wrike.com/) adopted it successfully for real products. I still remember, when Wrike developers talked about awesomeness of Dart in their talks, and everyone LOLed at them. *Types in Javascript-like language? LOL. In 1 year: OMG, TypeScript!!!.*

But Dart could not win, given the enormous spread of Javascript and other web tech (CSS, HTML). At first it parasited on top of that stack. But, that way was dead. They had to do something that would interest normal developers, that used to write in Java, Objective-C, C... All of that JavaScript souls were already corrupted and sat deep with [Stockholm syndrome](https://en.wikipedia.org/wiki/Stockholm_syndrome). For them it was absolutely okay to center something inside something  [by adding vodoo CSS magic](https://stackoverflow.com/questions/114543/how-to-horizontally-center-a-div). It was absolutely normal for them to use third-party library to check whether object is array or not. A person with clear mind would never use CSS Grid or what was another tech?...Flex grid? Flex box? *Nevermind, it is already considered bad.*

# And Google hit hard. With Flutter.

All of the points described in leaked memo they used as an advantage. Highly portable DartVM was ported to iOS, Web, Android. On top of that, they started from scratch a new layout engine. No more vodoo magic to center the content.

It is just

```dart
Center(
    child: Container()
)
```

That is all. You do not have to reset something in body tag in order for another cool feature to work. Want column? Want Row?

Easy:

```dart
Column(
  children: <Widget>[
    Text('Deliver features faster'),
    Text('Craft beautiful UIs'),
    Expanded(
      child: FittedBox(
        fit: BoxFit.contain, // otherwise the logo will be tiny
        child: const FlutterLogo(),
      ),
    ),
  ],
)
```

With the 10% of React Amsterdam budget they conducted the [first Flutter conference](https://www.youtube.com/watch?v=kpcjBD1XDwU). They announced that we could finally use something sane to build web applications: **Flutter for the Web**.

One code base now targeted three platforms:
- ✅Android
- ✅Web
- ✅iOS

# But that was not all.

They quickly brought up npm clone: https://pub.dev. You could host your packages and used them in identical way. The ecosystem flourished. Each week you got new packages, new widgets, new platform helpers.

Then quietly, without any announcements ~~and dedicated Flutter-Berlin-Conference early bird $800 ticket~~ the Dart and Flutter teams added support for desktops. FOR ALL OF THEM.

You can write app once and it works identically on all platforms supported:

- ✅Android
- ✅Web
- ✅iOS
- ✅Windows
- ✅Linux
- ✅macOS

No Chrome-Helpers, no ~~pile of hacks on top of another clay legs~~ React Native. Just a real native application rendering in Skia whatever layout you have.

# Progressive Web App

Without any announcements, Flutter team added support for the PWA. No configs, no webpack loaders required. You just build your app for the web and the amazing Flutter tooling does everything: registry of your resources and a CacheAPI dances around that. Boom, you now have installable Flutter Web Application.

But one thing was still missing: performance of the Flutter Web Applications was not so good. Specially on a miserable Meizu, Huawei, Pocco and other pseudo flagship devices. iPhones handled apps without the problems but some people still believe Android is free and open source so they continue using it.

I personally used Flutter PWA build of my  [citybuilding game](https://locadeserta.com/sloboda). I am enlightened enough to use top equipment (iPhone 11). But on a Galaxy flagship from Samsung the FPS could barely reach 20 FPS. Just like usual application written in Cordova/Ionic, which everybody hates but has to use it cause enterprise does not give a choice.

# The flag that changed the industry

*Remember this like that Windows XP pirated license key: **FLUTTER_WEB_USE_SKIA=true***

But then, on 24th of March, 2020, Sergey in our Ukrainian Flutter Telegram channel asked:

- Do you use FLUTTER_WEB_USE_SKIA=true for your web build?

And I remembered I tried that flag for Flutter PWA build in the September, it could not render PNG images and I quickly abandoned it.

**So I tried it again.**

And was shocked. These are not your enhancements you used to get after React Conference: render as you fetch, fetch as you render, render as you render and other bullshit performance nonsense.

**Just watch this:**

https://twitter.com/dmytrogladkyi/status/1243209712491008002?s=21

I did not include GIF here as it drops the frames.

**Watch another video again:**

https://twitter.com/dmytrogladkyi/status/1243147785836388352?s=21

That is Flutter PWA app installed on iPhone 11. Running 99% comparing to the natively built for the iOS app. The only lag you can see are the images being loaded for the first time. Then they are cached (each image is 1000x1000 so imagine the load on the CPU when you scroll that list of available Buildings).

# End of Dark Web App Age or the Fluttercalypsis

Without any announcements, without dedicating ~~sponsored talks by companies advertising their shit in expensive cities in Europe~~ conference Google just did what others could not do in last 30 years: brought the only framework that works on all platforms and does not stand on the back of JavaScript and CSS+HTML pile of bones.

[They cut it off](https://youtu.be/t0UwwjWzaGw?t=135). All of that crap is gone. You do not need to learn by heart CSS and JS nonsense. You are now in a complete freedom to write your app. Since 1995 you can start using logic and your math skills. People with developed brains are finally no longer hostages of masters in philosophy who know how to talk and have 200K followers in Twitter and Youtube. No more fights with webpack, anxiety after ~~yet another awesome frontend conference~~ new posts from thought leaders, complete reset of your knowledge each 3 years. Yes, your web knowledge is reset each three years. Do not believe me? Go do some interviews. Some of the interviewers will lol at you for not knowing yet another new JS 2050 feature which can be used only after adding 70 packages to the build system. You can even try pick any of the tech from 2017 and try to make a web app with it. Good. Luck.

# That Dark Age Has Ended.

# The Light Has Come

# The Future is Flutter
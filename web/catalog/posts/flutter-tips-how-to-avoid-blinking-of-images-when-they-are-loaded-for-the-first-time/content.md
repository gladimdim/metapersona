# The problem
In this small post I will show you how to avoid 'blinking images' when they are loaded into  [AssetImage](https://flutter.dev/docs/development/ui/assets-and-images)  widget for the first time.

In Flutter I use  [Hero Widget](https://flutter.dev/docs/development/ui/animations/hero-animations)  for cross widget animations. When the user navigates to another view I want widget to 'fly' into new scene with a smooth animation. But, as you can see in the gif below, it is not so  smooth:


![no_precache_small.gif](screen1.gif)

The issue is caused by spending too much time loading image from the assets. After the image is rendered at least once, it is cached and next renders do not take so much time. But how do we make sure that first render is smooth?

# The Solution

Use [precacheImage](https://api.flutter.dev/flutter/widgets/precacheImage.html) ! You can call it from didUpdateDependencies:

```
 @override
  void didChangeDependencies() {
    List<AssetImage> allImages =
    BackgroundImage.getRandomImageForType(ImageType.LANDING)
        .getAllAvailableImages();
    allImages.forEach((AssetImage image) {
      precacheImage(image, context);
    });
    super.didChangeDependencies();
  }
```

Now all renders of Hero Widget are smooth and do not blink or have instantaneous size changes:

![preache_small.gif](screen2.gif)



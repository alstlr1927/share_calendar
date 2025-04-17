import 'package:flutter/material.dart';

class CustomImageCache extends WidgetsFlutterBinding {
  @override
  ImageCache createImageCache() {
    ImageCache imageCache = super.createImageCache();
    imageCache.maximumSizeBytes = 100 * 1024 * 1024; //200mb 이상->캐시클리어
    return imageCache;
  }
}

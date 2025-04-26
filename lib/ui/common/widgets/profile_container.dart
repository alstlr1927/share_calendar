import 'package:couple_calendar/ui/common/widgets/couple_image.dart';
import 'package:couple_calendar/util/couple_util.dart';
import 'package:couple_calendar/util/images.dart';
import 'package:flutter/material.dart';

class ProfileContainer extends StatelessWidget {
  final double height;
  final double width;
  final String? url;
  final VoidCallback? onPressed;
  final Widget? overlay;
  final Clip clip;

  ProfileContainer.size40({
    this.clip = Clip.antiAlias,
    this.url,
    this.onPressed,
    this.overlay,
  })  : width = 40.toWidth,
        height = 40.toWidth;

  ProfileContainer.size80({
    this.clip = Clip.antiAlias,
    this.url,
    this.onPressed,
    this.overlay,
  })  : width = 80.toWidth,
        height = 80.toWidth;

  ProfileContainer.size100({
    this.clip = Clip.antiAlias,
    this.url,
    this.onPressed,
    this.overlay,
  })  : width = 100.toWidth,
        height = 100.toWidth;

  @override
  Widget build(BuildContext context) {
    debugPrint('url : ${url}');
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        child: ClipOval(
          clipBehavior: clip,
          child: Center(
            child: Builder(
              builder: (context) {
                if (url == '' || url == null) {
                  // empty
                  return _buildEmptyImage();
                }
                return _buildUrlImage();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUrlImage() {
    debugPrint('url : ${url}');
    return CoupleImage(
      width: width,
      height: height,
      imageUrl: url!,
      memCacheWidth: (width * 3).toInt(),
      cacheManager: CustomCacheManager(),
      fit: BoxFit.cover,
      errorWidget: (ctx, url, _) => _buildEmptyImage(),
    );
  }

  Image _buildEmptyImage() {
    return Image.asset(
      emptyProfileImg,
      width: width,
      height: height,
      cacheWidth: (width * 3).toInt(),
      fit: BoxFit.cover,
    );
  }
}

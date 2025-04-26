import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:octo_image/octo_image.dart';

typedef Widget ImageWidgetBuilder(
    BuildContext context, ImageProvider imageProvider);
typedef Widget PlaceholderWidgetBuilder(BuildContext context, String url);
typedef Widget ProgressIndicatorBuilder(
    BuildContext context, String url, DownloadProgress progress);
typedef Widget LoadingErrorWidgetBuilder(
    BuildContext context, String url, dynamic error);

enum ImageType {
  origin,
  banner,
  popup,
  other,
}

class CoupleImage extends StatefulWidget {
  final CachedNetworkImageProvider _image;

  /// Option to use cachemanager with other settings
  final BaseCacheManager? cacheManager;

  /// The target image that is displayed.
  String imageUrl;

  /// Optional builder to further customize the display of the image.
  final ImageWidgetBuilder? imageBuilder;

  /// Widget displayed while the target [imageUrl] is loading.
  final PlaceholderWidgetBuilder? placeholder;

  /// Widget displayed while the target [imageUrl] is loading.
  final ProgressIndicatorBuilder? progressIndicatorBuilder;

  /// Widget displayed while the target [imageUrl] failed loading.
  final LoadingErrorWidgetBuilder? errorWidget;

  /// The duration of the fade-in animation for the [placeholder].
  final Duration placeholderFadeInDuration;

  /// The duration of the fade-out animation for the [placeholder].
  final Duration fadeOutDuration;

  /// The curve of the fade-out animation for the [placeholder].
  final Curve fadeOutCurve;

  /// The duration of the fade-in animation for the [imageUrl].
  final Duration fadeInDuration;

  /// The curve of the fade-in animation for the [imageUrl].
  final Curve fadeInCurve;

  final double? width;

  final double? height;

  final BoxFit? fit;

  final Alignment alignment;

  final ImageRepeat repeat;

  final bool matchTextDirection;

  final Map<String, String>? httpHeaders;

  final bool useOldImageOnUrlChange;

  final Color? color;

  final BlendMode? colorBlendMode;

  final FilterQuality filterQuality;

  final int? memCacheWidth;

  final int? memCacheHeight;

  final Color backGroundColor;

  ImageType type;

  bool? adFlag;

  int? videoIdx;

  int? displayDetailIdx;

  String? pageLabel;
  String? linkUrl;

  CoupleImage({
    Key? key,
    this.imageUrl = '',
    this.httpHeaders,
    this.backGroundColor = Colors.black,
    this.imageBuilder,
    this.placeholder,
    this.progressIndicatorBuilder,
    this.errorWidget,
    this.fadeOutDuration = const Duration(milliseconds: 1000),
    this.fadeOutCurve = Curves.easeOut,
    this.fadeInDuration = const Duration(milliseconds: 500),
    this.fadeInCurve = Curves.easeIn,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.matchTextDirection = false,
    this.cacheManager,
    this.useOldImageOnUrlChange = false,
    this.color,
    this.filterQuality = FilterQuality.low,
    this.colorBlendMode,
    this.placeholderFadeInDuration = const Duration(milliseconds: 300),
    this.memCacheWidth,
    this.memCacheHeight,
  })  : _image = CachedNetworkImageProvider(
          imageUrl,
          headers: httpHeaders,
          cacheManager: CustomCacheManager(),
        ),
        type = ImageType.other,
        super(key: key);

  CoupleImage.origin({
    Key? key,
    required this.adFlag,
    required this.videoIdx,
    this.imageUrl = '',
    this.httpHeaders,
    this.backGroundColor = Colors.black,
    this.imageBuilder,
    this.placeholder,
    this.progressIndicatorBuilder,
    this.errorWidget,
    this.fadeOutDuration = const Duration(milliseconds: 1000),
    this.fadeOutCurve = Curves.easeOut,
    this.fadeInDuration = const Duration(milliseconds: 500),
    this.fadeInCurve = Curves.easeIn,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.matchTextDirection = false,
    this.cacheManager,
    this.useOldImageOnUrlChange = false,
    this.color,
    this.filterQuality = FilterQuality.low,
    this.colorBlendMode,
    this.placeholderFadeInDuration = const Duration(milliseconds: 300),
    this.memCacheWidth,
    this.memCacheHeight,
  })  : _image = CachedNetworkImageProvider(
          imageUrl,
          headers: httpHeaders,
          cacheManager: CustomCacheManager(),
        ),
        type = ImageType.origin,
        super(key: key);

  CoupleImage.banner({
    Key? key,
    required this.displayDetailIdx,
    required this.pageLabel,
    required this.linkUrl,
    this.imageUrl = '',
    this.httpHeaders,
    this.backGroundColor = Colors.black,
    this.imageBuilder,
    this.placeholder,
    this.progressIndicatorBuilder,
    this.errorWidget,
    this.fadeOutDuration = const Duration(milliseconds: 1000),
    this.fadeOutCurve = Curves.easeOut,
    this.fadeInDuration = const Duration(milliseconds: 500),
    this.fadeInCurve = Curves.easeIn,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.matchTextDirection = false,
    this.cacheManager,
    this.useOldImageOnUrlChange = false,
    this.color,
    this.filterQuality = FilterQuality.low,
    this.colorBlendMode,
    this.placeholderFadeInDuration = const Duration(milliseconds: 300),
    this.memCacheWidth,
    this.memCacheHeight,
  })  : _image = CachedNetworkImageProvider(
          imageUrl,
          headers: httpHeaders,
          cacheManager: CustomCacheManager(),
        ),
        type = ImageType.banner,
        super(key: key);

  CoupleImage.popup({
    Key? key,
    required this.displayDetailIdx,
    required this.pageLabel,
    required this.linkUrl,
    this.imageUrl = '',
    this.httpHeaders,
    this.backGroundColor = Colors.black,
    this.imageBuilder,
    this.placeholder,
    this.progressIndicatorBuilder,
    this.errorWidget,
    this.fadeOutDuration = const Duration(milliseconds: 1000),
    this.fadeOutCurve = Curves.easeOut,
    this.fadeInDuration = const Duration(milliseconds: 500),
    this.fadeInCurve = Curves.easeIn,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.matchTextDirection = false,
    this.cacheManager,
    this.useOldImageOnUrlChange = false,
    this.color,
    this.filterQuality = FilterQuality.low,
    this.colorBlendMode,
    this.placeholderFadeInDuration = const Duration(milliseconds: 300),
    this.memCacheWidth,
    this.memCacheHeight,
  })  : _image = CachedNetworkImageProvider(
          imageUrl,
          headers: httpHeaders,
          cacheManager: CustomCacheManager(),
        ),
        type = ImageType.popup,
        super(key: key);

  @override
  State<CoupleImage> createState() => _CoupleImageState();
}

class _CoupleImageState extends State<CoupleImage> {
  bool isLogged = false;

  @override
  void initState() {
    debugPrint('!!!imgProvURl : ${widget._image.url} ');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int defaultWidth = ScreenUtil().screenWidth.toInt();
    int cachedWidth = 0;

    if (widget.width == null) {
      cachedWidth = defaultWidth;
    } else if (widget.width == 0) {
      cachedWidth = defaultWidth;
    } else {
      if (widget.width!.isInfinite) {
        cachedWidth = defaultWidth;
      } else {
        cachedWidth = (widget.width?.toInt() ?? 0) + 200;
      }
    }

    if (widget.imageUrl == '') {
      return Container(
        width: widget.width,
        height: widget.height,
        color: widget.backGroundColor,
      );
    }

    debugPrint('이미지 이미지  :${widget.imageUrl}');

    return Container(
      width: widget.width,
      height: widget.height,
      color: widget.backGroundColor,
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          OctoImage(
            image: widget._image,
            imageBuilder:
                widget.imageBuilder != null ? _octoImageBuilder : null,
            placeholderBuilder: widget.placeholder != null
                ? _octoPlaceholderBuilder
                : (context) => Container(
                      width: widget.width,
                      height: widget.height,
                    ),
            progressIndicatorBuilder: widget.progressIndicatorBuilder != null
                ? _octoProgressIndicatorBuilder
                : null,
            errorBuilder: widget.errorWidget != null
                ? _octoErrorBuilder
                : (_, __, ___) => Container(),
            fadeOutDuration: widget.fadeOutDuration,
            fadeOutCurve: widget.fadeOutCurve,
            fadeInDuration: widget.fadeInDuration,
            fadeInCurve: widget.fadeInCurve,
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
            alignment: widget.alignment,
            repeat: widget.repeat,
            matchTextDirection: widget.matchTextDirection,
            color: widget.color,
            filterQuality: widget.filterQuality,
            colorBlendMode: widget.colorBlendMode,
            placeholderFadeInDuration: widget.placeholderFadeInDuration,
            gaplessPlayback: widget.useOldImageOnUrlChange,
            memCacheWidth: cachedWidth,
            memCacheHeight: widget.memCacheHeight,
          ),
        ],
      ),
    );
  }

  Widget _octoImageBuilder(BuildContext context, Widget child) {
    return widget.imageBuilder!(context, widget._image);
  }

  Widget _octoPlaceholderBuilder(BuildContext context) {
    return widget.placeholder!(context, widget.imageUrl);
  }

  Widget _octoProgressIndicatorBuilder(
    BuildContext context,
    ImageChunkEvent? progress,
  ) {
    int? totalSize;
    int downloaded = 0;
    if (progress != null) {
      totalSize = progress.expectedTotalBytes;
      downloaded = progress.cumulativeBytesLoaded;
    }
    return widget.progressIndicatorBuilder!(context, widget.imageUrl,
        DownloadProgress(widget.imageUrl, totalSize, downloaded));
  }

  Widget _octoErrorBuilder(
    BuildContext context,
    Object error,
    StackTrace? stackTrace,
  ) {
    return Container(
      color: Colors.white,
      child: widget.errorWidget!(context, '', null),
    );
  }
}

class CustomCacheManager extends CacheManager with ImageCacheManager {
  static const key = 'customCache';

  static CustomCacheManager? _instance;

  factory CustomCacheManager() {
    _instance ??= CustomCacheManager._();
    return _instance!;
  }

  CustomCacheManager._()
      : super(Config(
          key,
          maxNrOfCacheObjects: 100,
          stalePeriod: Duration(days: 3),
        ));
}

class CustomHttpFileService extends HttpFileService {
  CustomHttpFileService() : super();

  @override
  Future<FileServiceResponse> get(String url,
      {Map<String, String>? headers = const {}}) {
    if (url.startsWith('https')) {
      url = url.replaceFirst('https', 'http');
    }
    return super.get(url, headers: headers);
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:penilaian/app/data/services/local_services/flavor_local_services.dart';
import 'package:shimmer/shimmer.dart';

import 'empty_image.dart';

class ImageWithLoader extends StatelessWidget {
  ImageWithLoader({
    super.key,
    required this.imageUrl,
    this.size = 100,
    this.width,
    this.radius,
    this.child,
    this.boxShadow,
    this.borderRadius,
    this.isBG = false,
    this.fit,
    this.border,
  });

  final String imageUrl;
  final double size;
  final double? width;
  final double? radius;
  final Widget? child;
  final List<BoxShadow>? boxShadow;
  final BorderRadiusGeometry? borderRadius;
  final bool isBG;
  final BoxFit? fit;
  final BoxBorder? border;
  final local = FlavorLocalServicesImpl();

  @override
  Widget build(BuildContext context) {
    var image = imageUrl;
    if (!image.contains('http') && imageUrl != '') {
      image = local.baseUrl + image;
    }
    return image == ''
        ? EmptyImage(
            size: size,
            width: width ?? size,
          )
        : CachedNetworkImage(
            imageUrl: image,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.grey[200]!,
              highlightColor: Colors.white,
              child: EmptyImage(
                size: size,
                width: width ?? size,
                radius: radius,
              ),
            ),
            imageBuilder: (context, imageProvider) => Container(
              height: size,
              width: width ?? size,
              decoration: BoxDecoration(
                borderRadius: borderRadius ?? BorderRadius.circular(radius ?? (size / 10)),
                image: DecorationImage(
                  image: imageProvider,
                  fit: fit ?? BoxFit.cover,
                ),
                boxShadow: boxShadow,
                border: border,
              ),
              child: child,
            ),
            errorWidget: (context, url, error) => isBG
                ? Container(
                    height: size,
                    width: width ?? size,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(radius ?? (size / 10)),
                      color: Colors.white,
                      boxShadow: boxShadow,
                    ),
                  )
                : EmptyImage(
                    size: size,
                    width: width ?? size,
                    radius: radius,
                    child: const Center(
                      child: Icon(CupertinoIcons.photo, color: Colors.grey),
                    ),
                  ),
          );
  }
}

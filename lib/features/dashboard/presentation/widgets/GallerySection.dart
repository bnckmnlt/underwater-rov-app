import 'package:embedded_rov_v2/core/utils/no_data_display.dart';
import 'package:embedded_rov_v2/features/dashboard/domain/entities/image.dart';
import 'package:flutter/material.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class GallerySection extends StatefulWidget {
  final String title;
  final List<ImageRecord> itemList;

  final String titleGallery;
  final double deviceWidth;

  const GallerySection({
    super.key,
    required this.title,
    required this.itemList,
    required this.titleGallery,
    required this.deviceWidth,
  });

  @override
  State<GallerySection> createState() => _GallerySectionState();
}

class _GallerySectionState extends State<GallerySection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.025,
              ),
            ),
            Text(
              widget.itemList.length.toString(),
              style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.75),
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        widget.itemList.isNotEmpty
            ? GalleryImage(
                galleryBackgroundColor: Theme.of(context).colorScheme.surface,
                textStyleOfNumberWidget: const TextStyle(
                  color: Colors.white60,
                  fontFamily: "Geist Mono",
                  fontWeight: FontWeight.w600,
                  fontSize: 32,
                  letterSpacing: 0.025,
                ),
                loadingWidget: Center(
                  child: LoadingAnimationWidget.discreteCircle(
                    color: Colors.blueAccent,
                    size: 32,
                  ),
                ),
                crossAxisSpacing: 12,
                imageUrls:
                    widget.itemList.map((image) => image.filePath).toList(),
                numOfShowImages: widget.itemList.isNotEmpty
                    ? (widget.itemList.length < 3 ? widget.itemList.length : 3)
                    : 0,
                titleGallery: widget.titleGallery,
              )
            : Center(
                child: NoDataDisplay(
                  deviceWidth: widget.deviceWidth,
                  message: "No data available",
                ),
              ),
        const SizedBox(height: 16),
      ],
    );
  }
}

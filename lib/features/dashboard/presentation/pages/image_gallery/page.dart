import 'package:embedded_rov_v2/features/dashboard/domain/entities/image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:galleryimage/galleryimage.dart';

class ImageGallery extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (builder) => ImageGallery(
          imageRecords: [],
        ),
      );

  final List<ImageRecord> imageRecords;

  const ImageGallery({
    super.key,
    required this.imageRecords,
  });

  @override
  State<ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  late List<ImageRecord> imageRecords;

  @override
  void initState() {
    super.initState();

    imageRecords = widget.imageRecords;
  }

  @override
  Widget build(BuildContext context) {
    List<String> listOfUrls = [
      "https://cosmosmagazine.com/wp-content/uploads/2020/02/191010_nature.jpg",
      "https://scx2.b-cdn.net/gfx/news/hires/2019/2-nature.jpg",
      "https://isha.sadhguru.org/blog/wp-content/uploads/2016/05/natures-temples.jpg",
      "https://upload.wikimedia.org/wikipedia/commons/7/77/Big_Nature_%28155420955%29.jpeg",
      "https://s23574.pcdn.co/wp-content/uploads/Singular-1140x703.jpg",
      "https://www.expatica.com/app/uploads/sites/9/2017/06/Lake-Oeschinen-1200x675.jpg",
    ];

    return LayoutBuilder(
      builder: (BuildContext context, constraints) {
        double deviceHeight = constraints.maxHeight;
        double deviceWidth = constraints.maxWidth;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
                imageRecords.isNotEmpty && imageRecords.first.objectDetected
                    ? "All Objects Detected"
                    : "All Manual Capture"),
            elevation: 0.0,
            scrolledUnderElevation: 0,
            leadingWidth: 76,
            leading: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ButtonStyle(
                splashFactory: NoSplash.splashFactory,
                foregroundColor: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.onSurface,
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color:
                        Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  ),
                ),
                child: const Icon(
                  FluentIcons.arrow_left_24_filled,
                  size: 24.0,
                ),
              ),
            ),
          ),
          body: Container(
              height: deviceHeight,
              width: deviceWidth,
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: GalleryImage(
                imageUrls: imageRecords.map((image) => image.filePath).toList(),
                numOfShowImages: 4,
                titleGallery: "Hello",
              )),
        );
      },
    );
  }
}

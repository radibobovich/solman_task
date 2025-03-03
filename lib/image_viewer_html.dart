import 'package:flutter/material.dart';
import 'package:solman_task/image_viewer.dart';
import 'package:web/web.dart';

/// An implementation of [ImageViewer] using flutter_widget_from_html_core.
/// Much simpler than the original implementation and is not reliant on
/// dart:html package.
class ImageViewerHtml extends StatelessWidget {
  const ImageViewerHtml(
      {super.key, required this.imageUrl, required this.onDoubleClick});

  /// Url of the image to display.
  final String? imageUrl;

  /// Called when the user double-clicks on the image.
  final Function onDoubleClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => onDoubleClick(),
      child: AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: imageUrl == null || imageUrl!.isEmpty
                  ? SizedBox.shrink()
                  : Center(
                      child: HtmlElementView.fromTagName(
                          key: Key(imageUrl ?? ''),
                          tagName: 'img',
                          onElementCreated: (img) {
                            img as HTMLImageElement;
                            img.src = imageUrl ?? '';
                            img.style.width = '100%';
                            img.style.objectFit = 'contain';
                          }),
                    ),
            ),
          )),
    );
  }
}

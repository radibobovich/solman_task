import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:solman_task/image_viewer.dart';

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

  // Uses deprecated `<center>` tag, no other ways to center the image work
  String get html {
    return """
      <html>
        <center>
          <img src="$imageUrl" style="width:100%"/>
        </center>
      </html>
      """;
  }

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
                child: HtmlWidget(html)),
          )),
    );
  }
}

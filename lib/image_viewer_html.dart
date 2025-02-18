import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:solman_task/image_viewer.dart';

/// An implementation of [ImageViewer] using flutter_widget_from_html_core.
/// Much simpler than the original implementation and is not reliant on
/// dart:html package.
class ImageViewerHtml extends StatefulWidget {
  const ImageViewerHtml(
      {super.key, required this.imageUrl, required this.onDoubleClick});

  /// Url of the image to display.
  final String? imageUrl;

  /// Called when the user double-clicks on the image.
  final Function onDoubleClick;

  @override
  State<ImageViewerHtml> createState() => _ImageViewerHtmlState();
}

class _ImageViewerHtmlState extends State<ImageViewerHtml> {
  // Uses deprecated `<center>` tag, no other ways to center the image work
  String get html {
    return """
      <html>
        <center>
          <img src="${widget.imageUrl}"/>
        </center>
      </html>
      """;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: HtmlWidget(html)),
        ));
  }
}

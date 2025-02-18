import 'dart:async';
import 'dart:html' as html;
import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';

/// A widget for displaying the image based on [imageUrl].
/// The image fits like [BoxFit.contain].
class ImageViewer extends StatefulWidget {
  /// Url of the image to display.
  final String? imageUrl;

  /// Called when the user double-clicks on the image.
  final Function onDoubleClick;

  const ImageViewer({
    super.key,
    required this.imageUrl,
    required this.onDoubleClick,
  });

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

/// State of [ImageViewer].
class _ImageViewerState extends State<ImageViewer> {
  /// Stores a unique identifier for the `viewFactory`.
  late String viewType;

  /// Current canvas to render the image on.
  /// Cached to handle further layout in [_handleConstraintsUpdate].
  html.CanvasElement? currentCanvas;

  /// Current image displayed on the canvas.
  /// The image is reused in a new layout whenever the window size changes.
  html.ImageElement? currentImage;
  BoxConstraints? lastConstraints;

  /// Registers a view factory to render the canvas and the image.
  @override
  void initState() {
    registerViewFactory();
    super.initState();
  }

  /// Re-registers the view factory whenever the image url changes.
  @override
  void didUpdateWidget(covariant ImageViewer oldWidget) {
    if (oldWidget.imageUrl != widget.imageUrl) {
      registerViewFactory();
    }
    super.didUpdateWidget(oldWidget);
  }

  /// Creates a canvas to render the image on it, loads the image and handles
  /// the double click callback.
  void registerViewFactory() {
    // Create a unique identifier for the view to update it whenever
    // the image url changes.
    viewType = 'image-viewer-${DateTime.now().millisecondsSinceEpoch}';
    ui.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
      // `style.objectFit' doesn't work with the canvas implementation
      // and is omitted.
      final canvas = html.CanvasElement()
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.border = 'none';

      // Create an [ImageElement].
      final img = html.ImageElement()
        ..src = widget.imageUrl
        ..style.display = 'none';

      // Load and cache the image for futher layouts.
      img.onLoad.first.then((_) {
        currentImage = img;
        final ctx = canvas.getContext('2d') as html.CanvasRenderingContext2D;
        _fitImageToCanvas(canvas, ctx, img);
      });

      // Listen to double clicks and call the provided callback.
      canvas.onDoubleClick.listen((_) => widget.onDoubleClick());

      // Save/update reference to the canvas.
      currentCanvas = canvas;
      return canvas;
    });
  }

  /// Compares aspect ratios of the image and the canvas and fits the image
  /// in it behaving like [BoxFit.contain].
  void _fitImageToCanvas(html.CanvasElement canvas,
      html.CanvasRenderingContext2D ctx, html.ImageElement img) {
    // Get current canvas and image metrics.
    final rect = canvas.getBoundingClientRect();
    canvas.width = rect.width.toInt();
    canvas.height = rect.height.toInt();
    final canvasAspectRatio = canvas.width! / canvas.height!;

    final imgAspectRatio = img.width! / img.height!;

    // Properties are required to draw image on the canvas.
    double renderWidth;
    double renderHeight;
    double xOffset = 0;
    double yOffset = 0;

    // Handle different aspect ratio proportions.
    if (imgAspectRatio > canvasAspectRatio) {
      // Image is wider than canvas
      renderHeight = canvas.height!.toDouble();
      renderWidth = renderHeight * imgAspectRatio;
      xOffset = (canvas.width! - renderWidth) / 2;
    } else {
      // Image is taller than canvas
      renderWidth = canvas.width!.toDouble();
      renderHeight = renderWidth / imgAspectRatio;
      yOffset = (canvas.height! - renderHeight) / 2;
    }

    // Clears pixel area for the image.
    ctx.clearRect(0, 0, canvas.width!, canvas.height!);
    // Draw the image on the canvas.
    ctx.drawImageScaled(img, xOffset, yOffset, renderWidth, renderHeight);
  }

  /// Re-fits the image in the canvas whenever the window size changes.
  void _handleConstraintsUpdate(BoxConstraints constraints) {
    if (lastConstraints != constraints) {
      // Update the constraints.
      lastConstraints = constraints;

      // Get current canvas and re-fit the image in it as soon as possible.
      Future.microtask(() {
        if (currentCanvas != null && currentImage != null) {
          final ctx =
              currentCanvas!.getContext('2d') as html.CanvasRenderingContext2D;
          _fitImageToCanvas(currentCanvas!, ctx, currentImage!);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          _handleConstraintsUpdate(constraints);
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              // Use the [HtmlElementView] to render the registered view.
              child: HtmlElementView(viewType: viewType),
            ),
          );
        },
      ),
    );
  }
}

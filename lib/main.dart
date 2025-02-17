import 'package:flutter/material.dart';
import 'package:solman_task/fab_menu.dart';
import 'package:solman_task/fullscreen_handler.dart';
import 'package:solman_task/image_viewer.dart';

/// Entrypoint of the application.
void main() {
  runApp(const MyApp());
}

/// Application itself.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: const HomePage());
  }
}

/// [Widget] displaying the home page consisting of an image the the buttons.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// State of a [HomePage].
class _HomePageState extends State<HomePage> {
  /// A handler to track fullscreen toggling.
  late FullscreenHandler fullscreenHandler;

  /// Whether the fullscreen mode is enabled.
  bool isFullscreen = false;

  /// A controller for url [TextField] input.
  final TextEditingController urlController = TextEditingController();

  /// Current image url for [ImageViewer].
  String? url = '';

  /// A focus node to enable hit-enter-to-submit-url behavior.
  FocusNode confirmUrlButtonFocusNode = FocusNode();

  @override
  void initState() {
    // Focus the url submit button.
    confirmUrlButtonFocusNode.requestFocus();
    // Initialize the [fullscreenHandler].
    fullscreenHandler = FullscreenHandler((isFullscreen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() => this.isFullscreen = isFullscreen);
      });
    });
    super.initState();
  }

  /// Dipose of the [fullscreenHandler] to prevent memory leaks.
  @override
  void dispose() {
    fullscreenHandler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                    child: ImageViewer(
                  imageUrl: url,
                  onDoubleClick: () => fullscreenHandler.toggleFullScreen(),
                )),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: urlController,
                        onSubmitted: (_) => _submitUrl(urlController.text),
                        decoration: InputDecoration(hintText: 'Image URL'),
                      ),
                    ),
                    ElevatedButton(
                      autofocus: true,
                      focusNode: confirmUrlButtonFocusNode,
                      onPressed: () => _submitUrl(urlController.text),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                        child: Icon(Icons.arrow_forward),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 64),
              ],
            ),
          ),
        ),
        FloatingActionButtonMenu(
          isFullScreen: isFullscreen,
          toggleFullScreen: () => fullscreenHandler.toggleFullScreen(),
        ),
      ],
    );
  }

  /// Updates state with a new image url to refresh [ImageViewer].
  void _submitUrl(String text) {
    if (text.isEmpty) return;
    setState(() => url = text);
  }
}

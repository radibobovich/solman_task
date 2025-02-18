import 'package:flutter/material.dart';

/// A floating action button with a fullscreen toggle menu.
/// The menu opens on a "+" button press.
class FloatingActionButtonMenu extends StatefulWidget {
  const FloatingActionButtonMenu(
      {super.key, required this.toggleFullScreen, required this.isFullScreen});

  /// Called when user presses enter or exit fullscreen menu buttons, depending
  /// on [isFullScreen] value.
  final Function toggleFullScreen;

  /// Whether the fullscreen mode is on. Affects the menu behavior.
  final bool isFullScreen;

  @override
  State<FloatingActionButtonMenu> createState() =>
      _FloatingActionButtonMenuState();
}

/// State of a [FloatingActionButtonMenu].
class _FloatingActionButtonMenuState extends State<FloatingActionButtonMenu> {
  bool isMenuOpen = false;

  /// Toggles visibility of the fullscreen menu.
  void toggleMenu() => setState(() => isMenuOpen = !isMenuOpen);

  /// Closes the fullscreen toggle menu.
  void closeMenu() => setState(() => isMenuOpen = false);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Displays gray overlay while the menu is open.
        if (isMenuOpen)
          Positioned.fill(
            child: GestureDetector(
              onTap: () => closeMenu(),
              child: Container(color: Colors.black.withAlpha(150)),
            ),
          ),
        Positioned(
          bottom: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isMenuOpen) ...[
                FloatingActionButton.extended(
                  onPressed: () {
                    if (!widget.isFullScreen) {
                      widget.toggleFullScreen();
                      closeMenu();
                    }
                  },
                  label: const Text("Enter fullscreen"),
                  icon: const Icon(Icons.fullscreen),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.extended(
                  onPressed: () {
                    if (widget.isFullScreen) {
                      widget.toggleFullScreen();
                      closeMenu();
                    }
                  },
                  label: const Text("Exit fullscreen"),
                  icon: const Icon(Icons.fullscreen_exit),
                ),
                const SizedBox(height: 8),
              ],
              FloatingActionButton(
                onPressed: () => toggleMenu(),
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

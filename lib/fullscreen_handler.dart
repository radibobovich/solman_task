import 'dart:async';
import 'dart:html' as html;
import 'dart:js' as js;

/// A handler that subscribes to fullscreen mode changes.
class FullscreenHandler {
  /// Subscribes to messages sent from `web/fullscreen.js` and calls
  /// the callback whenever the fullscreen mode is being toggled.
  ///
  /// The callback should also be called if the tab was opened
  /// in fullscreen mode.
  FullscreenHandler(Function(bool) onFullScreenToggle) {
    // Try catching fullscreen at the tab loading.
    if (isInFullScreen()) onFullScreenToggle(true);

    _onMessageSubscription = html.window.onMessage.listen((event) {
      if (event.data is Map && event.data['type'] == 'fullscreen_toggled') {
        onFullScreenToggle(event.data['isFullscreen'] == true);
      }
    });
  }

  /// A subscription to js fullscreen toggling messages.
  late StreamSubscription<html.MessageEvent> _onMessageSubscription;

  /// Calls function defined in `web/fullscreen.js` file to toggle
  /// fullscreen mode.
  void toggleFullScreen() {
    js.context.callMethod('toggleFullScreen');
  }

  /// Checks if the fullscreen is enabled right now.
  bool isInFullScreen() {
    return js.context.callMethod('isInFullScreen');
  }

  /// Cancels the js message subscription to release resources.
  void dispose() {
    _onMessageSubscription.cancel();
  }
}

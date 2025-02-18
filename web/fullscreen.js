/// Requests fullscreen view from the browser.
/// Returns false if fullscreen mode is not supported, otherwise true.
function toggleFullScreen(){
    if (!document.fullscreenEnabled) return false;
    if (!isInFullScreen()){
        document.documentElement.requestFullscreen();
        return true;
    }
    else {
        document.exitFullscreen();
        return true;
    }
}

window.toggleFullScreen = toggleFullScreen;

document.addEventListener("fullscreenchange", () => {
    let isFullscreen = document.fullscreenElement ? true : false;
    window.parent.postMessage({type: "fullscreen_toggled", isFullscreen: isFullscreen}, "*")
})

/// Checks whtether the fullscreen mode is enabled.
function isInFullScreen() {
    if (document.fullscreenElement || document.webkitIsFullScreen || document.mozFullScreen) { 
      return true;
    }
    return false;
}
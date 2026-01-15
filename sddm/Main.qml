import "."
import QtQuick
import QtCore
import SddmComponents
import QtQuick.Effects
import QtMultimedia
import "components"

Item {
    id: root
    state: Config.lockScreenDisplay ? "lockState" : "loginState"

    // TODO: Add own translations: https://github.com/sddm/sddm/wiki/Localization
    TextConstants {
        id: textConstants
    }

    property bool capsLockOn: false
    Component.onCompleted: {
        if (keyboard)
            capsLockOn = keyboard.capsLock;
    }
    onCapsLockOnChanged: {
        loginScreen.updateCapsLock();
    }

    states: [
        State {
            name: "lockState"
            PropertyChanges {
                target: lockScreen
                opacity: 1.0
            }
            PropertyChanges {
                target: loginScreen
                opacity: 0.0
            }
            PropertyChanges {
                target: loginScreen.loginContainer
                scale: 0.5
            }
            PropertyChanges {
                target: backgroundEffect
                blurMax: Config.lockScreenBlur
                brightness: Config.lockScreenBrightness
                saturation: Config.lockScreenSaturation
            }
        },
        State {
            name: "loginState"
            PropertyChanges {
                target: lockScreen
                opacity: 0.0
            }
            PropertyChanges {
                target: loginScreen
                opacity: 1.0
            }
            PropertyChanges {
                target: loginScreen.loginContainer
                scale: 1.0
            }
            PropertyChanges {
                target: backgroundEffect
                blurMax: Config.loginScreenBlur
                brightness: Config.loginScreenBrightness
                saturation: Config.loginScreenSaturation
            }
        }
    ]
    transitions: Transition {
        enabled: Config.enableAnimations
        PropertyAnimation {
            duration: 150
            properties: "opacity"
        }
        PropertyAnimation {
            duration: 400
            properties: "blurMax"
        }
        PropertyAnimation {
            duration: 400
            properties: "brightness"
        }
        PropertyAnimation {
            duration: 400
            properties: "saturation"
        }
    }

    Item {
        id: mainFrame
        property variant geometry: screenModel.geometry(screenModel.primary)
        x: geometry.x
        y: geometry.y
        width: geometry.width
        height: geometry.height

        // AnimatedImage { // `.gif`s are seg faulting with multi monitors... QT/SDDM issue?
        Image {
            // Background
            id: backgroundImage
            property string tsource: root.state === "lockState" ? Config.lockScreenBackground : Config.loginScreenBackground

            property var videoExtensions: ["avi", "mp4", "mov", "mkv", "m4v", "webm"]

            function getFileExtension(filename) {
                if (!filename || filename.toString().length === 0)
                    return "";
                var parts = filename.toString().split(".");
                if (parts.length <= 1)
                    return "";
                return parts[parts.length - 1].toLowerCase();
            }

            function isVideoExtension(ext) {
                return videoExtensions.indexOf(ext) !== -1;
            }

            function resolveBackgroundPath(path) {
                if (!path || path.toString().length === 0)
                    return "";
                var pathStr = path.toString();
                // If path starts with ~/, expand to home directory
                if (pathStr.indexOf("~/") === 0) {
                    var homePath = StandardPaths.writableLocation(StandardPaths.HomeLocation);
                    return "file://" + homePath + pathStr.substring(1);
                }
                // If path starts with /, treat as absolute path
                if (pathStr.charAt(0) === "/")
                    return "file://" + pathStr;
                // Otherwise, resolve relative to backgrounds/ folder
                return Qt.resolvedUrl("backgrounds/" + pathStr);
            }

            property bool isVideo: false
            property bool triedVideoFallback: false
            property bool displayColor: root.state === "lockState" && Config.lockScreenUseBackgroundColor || root.state === "loginState" && Config.loginScreenUseBackgroundColor
            property string placeholder: Config.animatedBackgroundPlaceholder // Idea stolen from astronaut-theme. Not a fan of it, but works...

            anchors.fill: parent
            source: !isVideo ? resolveBackgroundPath(tsource) : ""
            cache: true
            mipmap: true
            fillMode: {
                if (Config.backgroundFillMode === "stretch") {
                    return Image.Stretch;
                } else if (Config.backgroundFillMode === "fit") {
                    return Image.PreserveAspectFit;
                } else {
                    return Image.PreserveAspectCrop;
                }
            }

            function updateVideo() {
                if (isVideo && tsource.toString().length > 0) {
                    backgroundVideo.source = resolveBackgroundPath(tsource);

                    if (placeholder.length > 0)
                        source = resolveBackgroundPath(placeholder);
                }
            }

            function initializeForSource() {
                var ext = getFileExtension(tsource);
                isVideo = isVideoExtension(ext);
                triedVideoFallback = false;
                if (isVideo) {
                    updateVideo();
                }
            }

            onTsourceChanged: {
                initializeForSource();
            }
            Component.onCompleted: {
                initializeForSource();
            }
            onStatusChanged: {
                if (status === Image.Error) {
                    var defaultBg = resolveBackgroundPath("default.jpg").toString();
                    var currentSource = source.toString();
                    var ext = getFileExtension(tsource);

                    // If not a known video extension and haven't tried video fallback, try loading as video
                    if (!isVideoExtension(ext) && !triedVideoFallback && tsource.toString().length > 0) {
                        triedVideoFallback = true;
                        isVideo = true;
                        updateVideo();
                    } else if (currentSource !== defaultBg && currentSource !== "") {
                        source = resolveBackgroundPath("default.jpg");
                    } else if (currentSource === defaultBg) {
                        // If even default fails, show color background
                        displayColor = true;
                    }
                }
            }

            Rectangle {
                id: backgroundColor
                anchors.fill: parent
                anchors.margins: 0
                color: root.state === "lockState" && Config.lockScreenUseBackgroundColor ? Config.lockScreenBackgroundColor : root.state === "loginState" && Config.loginScreenUseBackgroundColor ? Config.loginScreenBackgroundColor : "black"
                visible: parent.displayColor || (backgroundVideo.visible && parent.placeholder.length === 0)
            }

            // TODO: This is slow af. Removing the property bindings and doing everything at startup should help.
            Video {
                id: backgroundVideo
                anchors.fill: parent
                visible: parent.isVideo && !parent.displayColor
                enabled: visible
                autoPlay: false
                loops: MediaPlayer.Infinite
                muted: true
                fillMode: {
                    if (Config.backgroundFillMode === "stretch") {
                        return VideoOutput.Stretch;
                    } else if (Config.backgroundFillMode === "fit") {
                        return VideoOutput.PreserveAspectFit;
                    } else {
                        return VideoOutput.PreserveAspectCrop;
                    }
                }

                onSourceChanged: {
                    if (source && source.toString().length > 0) {
                        backgroundVideo.play();
                    }
                }
                onErrorOccurred: function (error) {
                    if (error !== MediaPlayer.NoError && (!backgroundImage.placeholder || backgroundImage.placeholder.length === 0)) {
                        backgroundImage.displayColor = true;
                    }
                }
            }

            // Overkill, but fine...
            Component.onDestruction: {
                if (backgroundVideo) {
                    backgroundVideo.stop();
                    backgroundVideo.source = "";
                }
            }
        }
        MultiEffect {
            // Background effects
            id: backgroundEffect
            source: backgroundImage
            anchors.fill: parent
            blurEnabled: backgroundImage.visible && blurMax > 0
            blur: blurMax > 0 ? 1.0 : 0.0
            autoPaddingEnabled: false
        }

        Item {
            id: screenContainer
            anchors.fill: parent
            anchors.top: parent.top

            LockScreen {
                id: lockScreen
                z: root.state === "lockState" ? 2 : 1 // Fix tooltips from the login screen showing up on top of the lock screen.
                anchors.fill: parent
                focus: root.state === "lockState"
                enabled: root.state === "lockState"
                onLoginRequested: {
                    root.state = "loginState";
                    loginScreen.resetFocus();
                }
            }
            LoginScreen {
                id: loginScreen
                z: root.state === "loginState" ? 2 : 1
                anchors.fill: parent
                enabled: root.state === "loginState"
                opacity: 0.0
                onClose: {
                    root.state = "lockState";
                }
            }
        }
    }
}
